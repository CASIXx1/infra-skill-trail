## 1. Goal
EventBridge Scheduler が毎分 ECS Fargate task を起動し、その task が New Relic Logs に `event_type=scheduled_new_relic_heartbeat` のログを 1 件送信できるようにする。

## 2. Approach
既存の責務分担に合わせ、Terraform は ECS cluster/IAM/ECR/CloudWatch Logs などの基盤を管理し、backend は task definition と container image を管理します。既存の API/worker task definition は backend 側の ecspresso 管理で、infra 側は `environments/dev/outputs.tf:336-367` のように ecspresso 用 env を tfstate に出しているため、scheduled task も同じ tfstate 契約を追加します。

Scheduler の `ecs_parameters.task_definition_arn` は family ARN を Terraform で組み立て、backend deploy が同じ family の task definition を登録します。これにより Terraform が backend の revision を知らなくても、Scheduler は最新 ACTIVE revision を実行できます。

## 3. File Changes
### infra-skill-trail
- Modify `modules/container-registry/repositories.tf:1-3`
  - `locals.repositories` に `scheduled-log` を追加し、既存の ECR lifecycle policy (`modules/container-registry/repositories.tf:16-50`) を同じルールで適用する。
- Modify `modules/container-registry/outputs.tf:1-23`
  - `scheduled_log_repository_url` output を追加する。
- Modify `modules/containers/logs.tf:1-14`
  - `/ecs/${var.name}/scheduled-log` の CloudWatch Log Group を追加する。
- Modify `modules/containers/iam.tf:12-18`
  - `local.task_log_group_arns` に scheduled-log log group ARN を追加し、既存の CloudWatch Logs IAM policy (`modules/containers/iam.tf:40-72`) の対象に含める。
- Modify `modules/containers/outputs.tf:11-39` and `modules/containers/outputs.tf:96-114`
  - `scheduled_log_log_group_name`, `scheduled_log_log_group_arn`, `scheduled_log_repository_url` を追加する。
- Create `modules/scheduler/variables.tf`
  - `name`, `cluster_arn`, `private_subnet_ids`, `security_group_id`, `task_role_arn`, `task_execution_role_arn`, `task_definition_family`, `schedule_expression` を定義する。`schedule_expression` の default は `rate(1 minute)`。
- Create `modules/scheduler/iam.tf`
  - `scheduler.amazonaws.com` trust の IAM role を作成する。
  - `ecs:RunTask` は `arn:${partition}:ecs:${region}:${account_id}:task-definition/${var.task_definition_family}:*` と family ARN 相当に絞る。
  - `iam:PassRole` は `var.task_role_arn` と `var.task_execution_role_arn` に絞り、`iam:PassedToService = ecs-tasks.amazonaws.com` condition を付ける。
- Create `modules/scheduler/schedule.tf`
  - `aws_scheduler_schedule` を作成し、`schedule_expression = var.schedule_expression`, `flexible_time_window.mode = "OFF"`, `target.arn = var.cluster_arn`, `target.role_arn = scheduler role ARN` を設定する。
  - `ecs_parameters.launch_type = "FARGATE"`, `platform_version = "LATEST"`, `task_count = 1`, `enable_execute_command = false`, `network_configuration.awsvpc_configuration.subnets = var.private_subnet_ids`, `security_groups = [var.security_group_id]`, `assign_public_ip = false` を設定する。
- Create `modules/scheduler/outputs.tf`
  - Scheduler name/ARN、role ARN、task definition family/ARN を出力する。
- Modify `environments/dev/modules.tf:57-77`
  - `module "scheduler"` を追加し、`module.containers.cluster_arn`, `module.network.private_subnet_ids`, `module.network.ecs_task_security_group_id`, `module.containers.task_role_arn`, `module.containers.task_execution_role_arn`, `task_definition_family = "${local.name}-scheduled-log"` を渡す。
  - `module.backend_deployment.log_group_names` (`environments/dev/modules.tf:64-68`) に scheduled-log log group を追加し、Actions がログ確認できるようにする。
- Modify `environments/dev/outputs.tf:16-34`, `environments/dev/outputs.tf:101-114`, `environments/dev/outputs.tf:336-367`
  - `scheduled_log_ecr_repository_url`, `scheduled_log_log_group_name`, `scheduled_log_task_definition_family`, `scheduled_log_scheduler_name`, `scheduled_log_scheduler_arn` を追加する。
  - `scheduled_log_ecspresso_env` を追加し、`ECS_CLUSTER_NAME`, `CONTAINER_NAME=scheduled-log`, `TASK_ROLE_ARN`, `TASK_EXECUTION_ROLE_ARN`, `SUBNET_IDS`, `SECURITY_GROUP_IDS`, `ASSIGN_PUBLIC_IP=false`, `LOG_GROUP_NAME`, `AWS_REGION` を含める。
- Modify `docs/terraform-dependencies.mmd:1-80`
  - container-registry に scheduled-log repository、containers に scheduled-log log group、scheduler module と ECS cluster/private subnet/security group/task roles の関係を追記する。
- Modify `README.md:36-84`
  - backend が参照する Terraform outputs に scheduled-log 関連を追加し、infra apply 後に backend deploy が task definition を登録する運用順を追記する。

### backend-skill-trail
- Create `cmd/scheduledlog/main.go`
  - 起動時に JSON を stdout に 1 件出して正常終了する。フィールドは `level`, `event_type`, `message`, `timestamp`, `source`, `schedule_name`。`SCHEDULE_NAME` 未設定時は `eventbridge-scheduler` を使う。
- Create `cmd/scheduledlog/main_test.go`
  - JSON 出力に `event_type=scheduled_new_relic_heartbeat` と RFC3339Nano timestamp が含まれること、`SCHEDULE_NAME` が反映されることをテストする。
- Create `Dockerfile.scheduled-log`
  - 既存 `Dockerfile.worker:1-24` と同じ multi-stage/distroless 構成で、`go build -o /scheduled-log ./cmd/scheduledlog` と `ENTRYPOINT ["/scheduled-log"]` を設定する。
- Create `ecspresso/scheduled-log/ecspresso.yml`
  - 既存 `ecspresso/worker/ecspresso.yml` と同じ tfstate plugin 構成にし、`region`, `cluster`, `service`, `task_definition` を scheduled-log 用 env で解決する。
- Create `ecspresso/scheduled-log/task-def.json`
  - `family` は `{{ tfstate \`output.scheduled_log_task_definition_family\` }}`。
  - `taskRoleArn` と `executionRoleArn` は `{{ tfstate \`output.ecs_task_role_arn\` }}` と `{{ tfstate \`output.ecs_task_execution_role_arn\` }}` を使う。
  - app container は `{{ tfstate \`output.scheduled_log_ecr_repository_url\` }}:{{ must_env \`IMAGE_TAG\` }}` を実行し、`logConfiguration` は既存 worker の New Relic FireLens 設定 (`ecspresso/worker/task-def.json:76-87`) と同じにする。
  - `log_router` container は既存 worker の FireLens sidecar (`ecspresso/worker/task-def.json:89-107`) と同じ構成で、`awslogs-group` だけ `{{ tfstate \`output.scheduled_log_log_group_name\` }}` にする。
  - `cpu=256`, `memory=512`, `runtimePlatform.cpuArchitecture=ARM64` は既存 worker (`ecspresso/worker/task-def.json:109-117`) に合わせる。
- Modify `.github/scripts/load-deploy-values.sh:70-92`
  - tfstate から `scheduled_log_ecr_repository_url`, `scheduled_log_ecspresso_env`, `scheduled_log_log_group_name`, `scheduled_log_task_definition_family` を読み込んで required output に追加する。
- Modify `.github/scripts/load-deploy-values.sh:99-120`
  - scheduled-log log group と New Relic/secret 関連 output を mask 対象に追加する。
- Modify `.github/scripts/load-deploy-values.sh:122-163`
  - `scheduled_log_ecspresso_env` の keys を `SCHEDULED_LOG_` prefix で `$GITHUB_ENV` に出す。`ASSIGN_PUBLIC_IP` は既存 `normalize_assign_public_ip` (`.github/scripts/load-deploy-values.sh:42-58`) を再利用する。
- Modify `.github/scripts/load-deploy-values.sh:176-196`
  - `SCHEDULED_LOG_ECR_REPOSITORY_URL`, `SCHEDULED_LOG_CONTAINER_NAME=scheduled-log`, `SCHEDULED_LOG_SCHEDULE_NAME`, `SCHEDULED_LOG_TASK_CPU=256`, `SCHEDULED_LOG_TASK_MEMORY=512` を `$GITHUB_ENV` に追加する。
- Modify `.github/workflows/deploy-backend.yml:44-84`
  - ECR login loop (`.github/workflows/deploy-backend.yml:44-52`) に scheduled-log repository URL を追加する。
  - `Dockerfile.scheduled-log` を使う Build and push scheduled-log image step を追加する。
- Modify `.github/workflows/deploy-backend.yml:91-103`
  - `ecspresso --config ecspresso/scheduled-log/ecspresso.yml render config` と `render task-definition` を追加する。
- Modify `.github/workflows/deploy-backend.yml:117-121`
  - API/worker deploy 後、`ecspresso --config ecspresso/scheduled-log/ecspresso.yml render task-definition > /tmp/scheduled-log-task-def.json` と `aws ecs register-task-definition --cli-input-json file:///tmp/scheduled-log-task-def.json` を追加し、service を作らず task definition だけ登録する。
- Modify `.github/workflows/ci.yml:45-69`
  - `Dockerfile.scheduled-log` の Docker build step を追加する。
- Modify `README.md:27-81` and `README.md:171-180`
  - scheduled-log image push、local ecspresso render、Scheduler smoke verification の手順を追記する。

## 4. Implementation Steps
### Task 1: Add Terraform foundation for scheduled ECS task
1. Update `modules/container-registry/repositories.tf:1-3` to include `scheduled-log` in the repository set.
2. Add scheduled-log repository output in `modules/container-registry/outputs.tf:1-23` and expose it through `modules/containers/outputs.tf:96-114`.
3. Add `/ecs/${var.name}/scheduled-log` in `modules/containers/logs.tf:1-14`.
4. Extend `modules/containers/iam.tf:12-18` so `task_cloudwatch_logs` includes the scheduled-log log group.
5. Add scheduled-log log group outputs in `modules/containers/outputs.tf:11-39`.

### Task 2: Add Scheduler module
1. Create `modules/scheduler/variables.tf` with explicit inputs for ECS cluster ARN, private subnet IDs, ECS task security group ID, task role ARN, execution role ARN, task definition family, and schedule expression.
2. Create `modules/scheduler/iam.tf` with `scheduler.amazonaws.com` assume role, scoped `ecs:RunTask`, and scoped `iam:PassRole`.
3. Create `modules/scheduler/schedule.tf` with `aws_scheduler_schedule` using `rate(1 minute)`, Fargate, private subnets, no public IP, one task per invocation.
4. Create `modules/scheduler/outputs.tf` for schedule identity and task definition family/ARN.

### Task 3: Wire Scheduler into dev root outputs and backend deploy role
1. Add `module "scheduler"` to `environments/dev/modules.tf:57-77` with `task_definition_family = "${local.name}-scheduled-log"`.
2. Add scheduled-log log group to `module.backend_deployment.log_group_names` in `environments/dev/modules.tf:64-68`.
3. Add scheduled-log tfstate outputs near existing ECR/log outputs in `environments/dev/outputs.tf:16-34` and `environments/dev/outputs.tf:101-114`.
4. Add `scheduled_log_ecspresso_env` next to existing `worker_ecspresso_env` and `migration_ecspresso_env` in `environments/dev/outputs.tf:336-367`.

### Task 4: Add backend scheduled-log command and image
1. Create `cmd/scheduledlog/main.go` with a small pure-Go logger that writes one JSON event and exits 0.
2. Create `cmd/scheduledlog/main_test.go` covering default schedule name, custom `SCHEDULE_NAME`, and parseable timestamp.
3. Create `Dockerfile.scheduled-log` using the same Go 1.23.4/distroless pattern as `Dockerfile.worker:1-24`.
4. Add scheduled-log image build to `.github/workflows/ci.yml:45-69`.

### Task 5: Add backend scheduled-log task definition registration
1. Create `ecspresso/scheduled-log/ecspresso.yml` using the same tfstate plugin pattern as existing ecspresso configs.
2. Create `ecspresso/scheduled-log/task-def.json`, copying the New Relic FireLens/log_router pattern from `ecspresso/worker/task-def.json:76-107` and changing image/log group/family/container name to scheduled-log.
3. Extend `.github/scripts/load-deploy-values.sh:70-196` to load and export scheduled-log tfstate values and env.
4. Extend `.github/workflows/deploy-backend.yml:44-84` to login/build/push the scheduled-log image.
5. Extend `.github/workflows/deploy-backend.yml:91-121` to render scheduled-log config/task definition and register it with `aws ecs register-task-definition` without creating a long-running ECS service.

### Task 6: Documentation
1. Update `README.md` in infra with new Terraform outputs and deployment sequencing.
2. Update `docs/terraform-dependencies.mmd:1-80` with Scheduler, scheduled-log ECR repository, and log group relationships.
3. Update backend `README.md:27-81` with local push/render commands for scheduled-log and operational verification commands.

## 5. Acceptance Criteria
1. Terraform plan includes one new ECR repository named `${project}-${environment}-scheduled-log` from `modules/container-registry/repositories.tf:1-8`.
2. Terraform plan includes one new CloudWatch Log Group named `/ecs/${project}-${environment}/scheduled-log` from `modules/containers/logs.tf:1-14`.
3. Terraform plan includes one `aws_scheduler_schedule` with `schedule_expression = "rate(1 minute)"`, `launch_type = "FARGATE"`, private subnet IDs, ECS task security group, and `assign_public_ip = false`.
4. Terraform plan includes a Scheduler IAM role that trusts only `scheduler.amazonaws.com` and grants `ecs:RunTask` only to the scheduled-log task definition family/revisions.
5. Terraform outputs include non-empty `scheduled_log_ecr_repository_url`, `scheduled_log_log_group_name`, `scheduled_log_task_definition_family`, and `scheduled_log_ecspresso_env`.
6. Backend `go test ./...` passes, including `cmd/scheduledlog` tests.
7. Backend `go vet ./...` passes.
8. CI Docker build includes `Dockerfile.scheduled-log` and builds for `linux/arm64`.
9. Deploy workflow logs into the scheduled-log ECR repository, pushes `${SCHEDULED_LOG_ECR_REPOSITORY_URL}:${IMAGE_TAG}`, renders the scheduled-log task definition, and registers it with ECS.
10. The registered scheduled-log task definition has two containers: `scheduled-log` and `log_router`.
11. The scheduled-log app container uses `awsfirelens` with New Relic `apiKey` secret from `output.external_service_secret_arn`, matching the existing worker pattern in `ecspresso/worker/task-def.json:76-87`.
12. After infra apply and backend deploy, ECS stopped tasks for family `${project}-${environment}-scheduled-log` appear about once per minute and exit with code 0.
13. New Relic Logs contains at least one event where `event_type = 'scheduled_new_relic_heartbeat'` within 5 minutes of backend deploy completion.

## 6. Verification Steps
### infra-skill-trail
1. Run `cd environments/dev && terraform fmt -recursive`.
2. Run `cd environments/dev && terraform init -backend-config=backend.hcl` if `.terraform/` is not initialized for the S3 backend.
3. Run `cd environments/dev && terraform validate`.
4. Run `cd environments/dev && terraform plan` and confirm acceptance criteria 1-5.

### backend-skill-trail
1. Run `go test ./...`.
2. Run `go vet ./...`.
3. Run Docker build locally if Docker is available: `docker build --platform linux/arm64 -f Dockerfile.scheduled-log -t backend-skill-trail-scheduled-log:ci .`.
4. Render the task definition with a real tfstate URL: `ecspresso --envfile .env --config ecspresso/scheduled-log/ecspresso.yml render task-definition`.
5. After deploy, verify ECS registrations: `aws ecs list-task-definitions --family-prefix ${project}-${environment}-scheduled-log --status ACTIVE`.
6. After deploy, verify scheduled invocations: `aws ecs list-tasks --cluster ${ECS_CLUSTER_NAME} --family ${project}-${environment}-scheduled-log --desired-status STOPPED`.
7. Query New Relic Logs for `event_type = 'scheduled_new_relic_heartbeat'` over the last 5 minutes.

## 7. Risks & Mitigations
- Risk: Terraform creates the Scheduler before backend registers the task definition family, so early invocations may fail until backend deploy completes. Mitigation: document and use the order `terraform apply` then backend deploy; Scheduler should recover automatically once an ACTIVE task definition exists.
- Risk: If EventBridge Scheduler validates a revisioned task definition ARN at schedule creation time in this AWS provider/API path, the family ARN approach may fail during `terraform apply`. Mitigation: if `terraform plan/apply` reports validation on the task definition ARN, change `modules/scheduler` to accept a `scheduled_log_task_definition_arn` variable and add a two-step apply after backend registration; keep this as a fallback only because it weakens the current Terraform/backend separation.
- Risk: Registering a rendered ecspresso task definition with `aws ecs register-task-definition --cli-input-json` may require stripping fields if ecspresso render includes ECS response-only fields. Mitigation: verify render output before the workflow update; if needed, pipe through `jq` to keep only register-task-definition input fields (`family`, `taskRoleArn`, `executionRoleArn`, `networkMode`, `containerDefinitions`, `requiresCompatibilities`, `cpu`, `memory`, `runtimePlatform`).
- Risk: New Relic delivery depends on `external_service_secret_arn` containing `NEW_RELIC_LICENSE_KEY`, which existing API/worker FireLens tasks already assume via `ecspresso/worker/task-def.json:81-85`. Mitigation: reuse the exact secretOptions shape and verify with a New Relic log query after deploy.