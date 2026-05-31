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
```

`backend.hcl` はローカル設定としてGit管理しない。実際に使うS3 bucketは事前に作成しておく。

## Application repositories

- Backend: https://github.com/CASIXx1/backend-skill-trail
- Frontend: https://github.com/CASIXx1/front-skill-trail

BackendのECS service/task definitionはecspresso側で管理する。Terraform側ではECS cluster、IAM role、network、security group、ALB、ECR、CloudWatch LogsなどのAWS基盤を管理する。

API ServiceのFireLens構成では、TerraformがCloudWatch Logs log groupを作成し、`api_ecspresso_env` outputで`LOG_GROUP_NAME`と`AWS_REGION`をecspressoへ渡す。ecspresso側ではAPIコンテナのlog driverを`awsfirelens`にし、FireLens sidecarの出力先としてこのlog groupを使う。
