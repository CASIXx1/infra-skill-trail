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
cd environments/shared
cp backend.example.hcl backend.hcl
terraform init -backend-config=backend.hcl
terraform apply

cd environments/dev
cp backend.example.hcl backend.hcl
terraform init -backend-config=backend.hcl
```

`backend.hcl` はローカル設定としてGit管理しない。実際に使うS3 bucketは事前に作成しておく。

`environments/shared` はECR repositoryなど、検証環境をdestroyしても残す共有リソースを管理する。ECR repositoryは`modules/container-registry`で作成する。`environments/dev` はECR repositoryを作成せず、`modules/containers`内で既存ECRを`data "aws_ecr_repository"`として参照するため、devのapply/destroy前にsharedをapplyしてECR repositoryを作成しておく。

## Application repositories

- Backend: https://github.com/CASIXx1/backend-skill-trail
- Frontend: https://github.com/CASIXx1/front-skill-trail

BackendのECS service/task definitionはecspresso側で管理する。Terraform側ではnetwork、security group、ALB、ECS cluster、IAM role、CloudWatch LogsなどのAWS基盤を管理する。ECR repositoryは`environments/shared`で管理し、`environments/dev`から参照する。

API ServiceのFireLens構成では、TerraformがCloudWatch Logs log groupを作成し、`api_ecspresso_env` outputで`LOG_GROUP_NAME`と`AWS_REGION`をecspressoへ渡す。ecspresso側ではAPIコンテナのlog driverを`awsfirelens`にし、FireLens sidecarの出力先としてこのlog groupを使う。
