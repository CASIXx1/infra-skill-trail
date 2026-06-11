# AGENTS.md

## Repository Overview

This repository manages AWS infrastructure for the Skill Trail application with Terraform.

- Terraform root module: `environments/dev`
- Reusable Terraform modules: `modules/*`
- Architecture/dependency docs: `docs/*`
- Application repositories are separate:
  - Backend: `https://github.com/CASIXx1/backend-skill-trail`
  - Frontend: `https://github.com/CASIXx1/front-skill-trail`

Terraform owns AWS foundation resources such as networking, security groups, ALB, ECS cluster, IAM roles, CloudWatch Logs, ECR repositories, Aurora PostgreSQL, and cache resources. Backend ECS service and task definitions are managed by ecspresso in the backend repository.

## Required Tooling

- Use Terraform `1.15.4` series.
- The root module uses `required_version = "~> 1.15.4"`, so older Terraform versions such as `1.14.x` will fail during `terraform init`.

## Terraform Workflow

Run Terraform commands from the environment root unless there is a specific reason to work inside a child module:

```bash
cd environments/dev
terraform fmt -recursive
terraform init -backend-config=backend.hcl
terraform validate
terraform plan
```

Use the S3 backend for shared state. Start from `backend.example.hcl` when configuring a local backend file:

```bash
cp backend.example.hcl backend.hcl
```

`backend.hcl` is local configuration and must not be committed.

## Local And Secret Files

Do not commit local state, secrets, or machine-specific Terraform inputs.

- Keep `backend.hcl` out of Git.
- Treat `terraform.tfvars` as environment-specific and sensitive.
- Prefer updating `terraform.tfvars.example` when documenting new variables.
- Do not commit `.terraform/` directories or generated plan files.
- Be careful with `terraform.tfstate`; this repository expects team state to live in S3.

## Module Conventions

- Keep environment composition in `environments/dev/modules.tf`.
- Keep reusable AWS resource definitions inside `modules/<domain>`.
- Add module inputs in `variables.tf` and module outputs in `outputs.tf`.
- Prefer explicit, narrowly scoped IAM permissions.
- Preserve existing naming patterns based on project/environment locals.
- Run `terraform fmt -recursive` after editing Terraform files.

## Destroy Workflow

ECR repositories can block `terraform destroy` when images remain. Before destroying the dev environment, run the cleanup script from the dev root:

```bash
cd environments/dev
./scripts/cleanup-destroy-blockers.sh
./scripts/cleanup-destroy-blockers.sh --yes
terraform destroy
```

Do not run destructive commands unless the user explicitly asks for them.

## Cross-Repository Contracts

Backend deployment depends on Terraform outputs from the dev root. Be cautious when renaming or removing outputs used by the backend repository, including:

- `firelens_ecr_repository_url`
- `new_relic_firelens_image`
- `external_service_secret_arn`
- `database_app_user_secret_arn`
- `database_migration_user_secret_arn`
- `new_relic_log_endpoint`
- `api_log_group_name`
- `migration_log_group_name`

For database access, API and worker tasks should use `database_app_user_secret_arn`; migration tasks should use `database_migration_user_secret_arn`.

## Validation Expectations

For infrastructure changes, prefer this verification sequence when feasible:

```bash
cd environments/dev
terraform fmt -recursive
terraform validate
terraform plan
```

If `terraform init` is required, use the configured S3 backend with `backend.hcl`. If credentials, backend configuration, or network access are unavailable, report that clearly instead of inventing plan results.
