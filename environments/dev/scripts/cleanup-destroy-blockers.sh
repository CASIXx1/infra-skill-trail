#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/cleanup-destroy-blockers.sh [--profile AWS_PROFILE] [--yes]

Empties resources that commonly block `terraform destroy` in the dev environment.

By default this script runs in dry-run mode. Pass --yes to delete:
- all images in ECR repositories from Terraform output `repository_urls`
- all objects in S3 buckets found in the Terraform state

Run this from environments/dev after `terraform init`.
EOF
}

confirm=false
aws_profile="${AWS_PROFILE:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes)
      confirm=true
      shift
      ;;
    --profile)
      if [[ $# -lt 2 || -z "$2" ]]; then
        echo "--profile requires a value." >&2
        exit 1
      fi
      aws_profile="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -f "backend.tf" || ! -f "outputs.tf" ]]; then
  echo "Run this script from environments/dev." >&2
  exit 1
fi

if [[ "$confirm" != "true" ]]; then
  cat <<'EOF'
Dry-run mode.
Re-run with --yes to delete ECR images and S3 objects.
EOF
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

if [[ -z "$aws_profile" && -f "terraform.tfvars" ]]; then
  aws_profile="$(
    awk -F= '$1 ~ /^[[:space:]]*aws_profile[[:space:]]*$/ {
      gsub(/[[:space:]"]/, "", $2)
      print $2
      exit
    }' terraform.tfvars
  )"
fi

aws_cli=(aws)

if [[ -n "$aws_profile" && "$aws_profile" != "null" ]]; then
  aws_cli+=(--profile "$aws_profile")
  echo "Using AWS profile: $aws_profile"
fi

delete_ecr_images() {
  local repository_name="$1"
  local image_ids_file="$tmp_dir/${repository_name//\//_}-image-ids.json"

  echo "ECR repository: $repository_name"

  while true; do
    "${aws_cli[@]}" ecr list-images \
      --repository-name "$repository_name" \
      --query 'imageIds' \
      --output json > "$image_ids_file"

    if python3 - "$image_ids_file" <<'PY'
import json
import sys

with open(sys.argv[1]) as f:
    image_ids = json.load(f)

sys.exit(0 if image_ids else 1)
PY
    then
      if [[ "$confirm" == "true" ]]; then
        "${aws_cli[@]}" ecr batch-delete-image \
          --repository-name "$repository_name" \
          --image-ids "file://$image_ids_file" >/dev/null
        echo "  deleted one batch of images"
      else
        echo "  images found"
        break
      fi
    else
      echo "  no images"
      break
    fi
  done
}

terraform output -json repository_urls > "$tmp_dir/repository-urls.json"

python3 - "$tmp_dir/repository-urls.json" <<'PY' > "$tmp_dir/ecr-repositories.txt"
import json
import sys

with open(sys.argv[1]) as f:
    repository_urls = json.load(f)

for repository_url in repository_urls.values():
    print(repository_url.split("/", 1)[1])
PY

while IFS= read -r repository_name; do
  [[ -n "$repository_name" ]] || continue
  delete_ecr_images "$repository_name"
done < "$tmp_dir/ecr-repositories.txt"

terraform state list | grep 'aws_s3_bucket\.' > "$tmp_dir/s3-bucket-addresses.txt" || true

while IFS= read -r bucket_address; do
  [[ -n "$bucket_address" ]] || continue

  bucket_name="$(
    terraform state show -no-color "$bucket_address" |
      awk '$1 == "bucket" && $2 == "=" { gsub(/"/, "", $3); print $3; exit }'
  )"

  [[ -n "$bucket_name" ]] || continue

  echo "S3 bucket: $bucket_name"

  if [[ "$confirm" == "true" ]]; then
    "${aws_cli[@]}" s3 rm "s3://$bucket_name" --recursive
  else
    echo "  would delete all objects"
  fi
done < "$tmp_dir/s3-bucket-addresses.txt"
