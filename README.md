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

- `api_ecr_repository_url`
- `worker_ecr_repository_url`
- `migration_ecr_repository_url`
- `firelens_ecr_repository_url`
- `new_relic_firelens_image`
- `external_service_secret_arn`
- `database_app_user_secret_arn`
- `database_migration_user_secret_arn`
- `new_relic_log_endpoint`
- `api_log_group_name`
- `worker_log_group_name`
- `migration_log_group_name`
- `worker_queue_url`
- `worker_queue_arn`
- `api_ecs_service_name`
- `worker_ecs_service_name`
- `api_target_group_arn`
- `private_subnet_ids`
- `worker_ecspresso_env`

AWS環境のBackend ECS task definitionでは、アプリケーション用DBユーザーのSecrets Manager ARNとしてTerraform output `database_app_user_secret_arn` を参照する。migration task definitionでは、migration用DBユーザーのSecrets Manager ARNとしてTerraform output `database_migration_user_secret_arn` を参照する。インフラ側ではAurora PostgreSQLへmaster userで接続し、以下のSQLを実行してDBユーザーと権限を作成する。

```sql
CREATE USER appuser WITH PASSWORD 'apppassword';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO appuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO appuser;

CREATE USER migrationuser WITH PASSWORD 'migrationpassword';
GRANT ALL PRIVILEGES ON DATABASE app TO migrationuser;
GRANT ALL PRIVILEGES ON SCHEMA public TO migrationuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO migrationuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO migrationuser;
```

Backend側へは、API serviceとworker serviceは`database_app_user_secret_arn`を使い、migration taskは`database_migration_user_secret_arn`を使うことを連携する。どちらのsecretも`username`、`password`、`engine`、`host`、`port`、`dbname`を含むJSON形式である。

Worker機能では、Terraformが標準SQS queue、DLQ、queue scoped IAM policy、worker用CloudWatch Log Groupを管理する。Backend側のecspressoは、Terraform output `worker_queue_url`、`worker_log_group_name`、`worker_ecs_service_name`、`worker_ecspresso_env`を使ってworker ECS service/task definitionを管理する。

Terraform側ではFireLens custom image用ECR repositoryを`environments/dev`で作成する。GitHub Actions backend deploy roleにはこのrepositoryへのpush権限と、Terraform output `api_log_group_name`、`migration_log_group_name`、`worker_log_group_name` のログイベントを参照するための`logs:GetLogEvents`権限を付与する。ECS task execution roleにはFireLens image pull権限と、New Relic License Keyを含む外部サービスsecretの取得権限を付与する。CloudWatch Logsへの通常ログ出力はECS task roleに付与した`logs:CreateLogStream`、`logs:PutLogEvents`で行う。
