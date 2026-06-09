# infra-skill-trail
スキル管理アプリのインフラリポジトリ

## Terraform version

このリポジトリではTerraform `1.15.4` 系を使う。

```bash
terraform version
```

`1.14.x` など古いTerraformでは `required_version = "~> 1.15.4"` により `terraform init` が失敗する。
Terraformを `1.15.4` に更新してから実行する。

## Terraform state

tfstateはS3 backendでチーム共有する。

```bash
cd environments/dev
cp backend.example.hcl backend.hcl
terraform init -backend-config=backend.hcl
terraform apply
```

`backend.hcl` はローカル設定としてGit管理しない。実際に使うS3 bucketは事前に作成しておく。

ECR repositoryは`environments/dev`内の`modules/container-registry`で作成する。ECR repository内にimageが残っていると`terraform destroy`が失敗するため、destroy前にcleanup scriptを実行する。

```bash
cd environments/dev
./scripts/cleanup-destroy-blockers.sh
./scripts/cleanup-destroy-blockers.sh --yes
terraform destroy
```

## Application repositories

- Backend: https://github.com/CASIXx1/backend-skill-trail
- Frontend: https://github.com/CASIXx1/front-skill-trail

BackendのECS service/task definitionはecspresso側で管理する。Terraform側ではnetwork、security group、ALB、ECS cluster、IAM role、CloudWatch Logs、ECR repositoryなどのAWS基盤を管理する。

API ServiceのFireLens構成では、Backend側でFireLens custom imageをbuildし、Terraform output `firelens_ecr_repository_url` のECR repositoryへpushする。FargateではFireLens custom configのS3直接参照を使わず、image内のconfig fileを参照する。

```json
"firelensConfiguration": {
  "type": "fluentbit",
  "options": {
    "enable-ecs-log-metadata": "true",
    "config-file-type": "file",
    "config-file-value": "/fluent-bit/etc/fluent-bit-custom.conf"
  }
}
```

Backend側では以下のTerraform root outputを参照する。

- `firelens_ecr_repository_url`
- `new_relic_firelens_image`
- `external_service_secret_arn`
- `new_relic_log_endpoint`
- `api_log_group_name`

Terraform側ではFireLens custom image用ECR repositoryを`environments/dev`で作成する。GitHub Actions backend deploy roleにはこのrepositoryへのpush権限を付与する。ECS task execution roleにはFireLens image pull権限と、New Relic License Keyを含む外部サービスsecretの取得権限を付与する。CloudWatch Logsへの通常ログ出力はECS task roleに付与した`logs:CreateLogStream`、`logs:PutLogEvents`で行う。
