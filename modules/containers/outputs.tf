output "cluster_arn" {
  description = "ECS cluster ARN."
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "api_log_group_name" {
  description = "CloudWatch Logs log group name for the API ECS service."
  value       = aws_cloudwatch_log_group.api.name
}

output "api_log_group_arn" {
  description = "CloudWatch Logs log group ARN for the API ECS service."
  value       = aws_cloudwatch_log_group.api.arn
}

output "migration_log_group_name" {
  description = "CloudWatch Logs log group name for migration tasks."
  value       = aws_cloudwatch_log_group.migration.name
}

output "migration_log_group_arn" {
  description = "CloudWatch Logs log group ARN for migration tasks."
  value       = aws_cloudwatch_log_group.migration.arn
}

output "worker_log_group_name" {
  description = "CloudWatch Logs log group name for the worker ECS service."
  value       = aws_cloudwatch_log_group.worker.name
}

output "worker_log_group_arn" {
  description = "CloudWatch Logs log group ARN for the worker ECS service."
  value       = aws_cloudwatch_log_group.worker.arn
}

output "scheduled_log_log_group_name" {
  description = "CloudWatch Logs log group name for the scheduled log ECS task."
  value       = aws_cloudwatch_log_group.scheduled_log.name
}

output "scheduled_log_log_group_arn" {
  description = "CloudWatch Logs log group ARN for the scheduled log ECS task."
  value       = aws_cloudwatch_log_group.scheduled_log.arn
}

output "external_service_secret_arn" {
  description = "Secrets Manager secret ARN for external service keys."
  value       = data.aws_secretsmanager_secret.external_service.arn
}

output "new_relic_license_key_secret_arn" {
  description = "Secrets Manager secret ARN for the New Relic license key."
  value       = data.aws_secretsmanager_secret.external_service.arn
}

output "new_relic_firelens_image" {
  description = "New Relic FireLens Fluent Bit image."
  value       = local.new_relic_firelens_image
}

output "task_execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = aws_iam_role.task_execution.arn
}

output "task_execution_role_name" {
  description = "ECS task execution role name."
  value       = aws_iam_role.task_execution.name
}

output "task_role_arn" {
  description = "ECS task role ARN."
  value       = aws_iam_role.task.arn
}

output "task_role_name" {
  description = "ECS task role name."
  value       = aws_iam_role.task.name
}

output "api_task_role_arn" {
  description = "ECS task role ARN for the API service."
  value       = aws_iam_role.api_task.arn
}

output "api_task_role_name" {
  description = "ECS task role name for the API service."
  value       = aws_iam_role.api_task.name
}

output "repository_urls" {
  description = "ECR repository URLs keyed by workload name."
  value       = var.ecr_repository_urls
}

output "repository_arns" {
  description = "ECR repository ARNs keyed by workload name."
  value       = var.ecr_repository_arns
}

output "api_repository_url" {
  description = "API ECR repository URL."
  value       = var.ecr_repository_urls["api"]
}

output "worker_repository_url" {
  description = "Worker ECR repository URL."
  value       = var.ecr_repository_urls["worker"]
}

output "migration_repository_url" {
  description = "Migration ECR repository URL."
  value       = var.ecr_repository_urls["migration"]
}

output "scheduled_log_repository_url" {
  description = "Scheduled log ECR repository URL."
  value       = var.ecr_repository_urls["scheduled-log"]
}

output "firelens_repository_url" {
  description = "FireLens ECR repository URL."
  value       = var.ecr_repository_urls["firelens"]
}
