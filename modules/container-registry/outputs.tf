output "repository_urls" {
  description = "ECR repository URLs keyed by workload name."
  value       = { for key, repository in aws_ecr_repository.this : key => repository.repository_url }
}

output "repository_arns" {
  description = "ECR repository ARNs keyed by workload name."
  value       = { for key, repository in aws_ecr_repository.this : key => repository.arn }
}

output "api_repository_url" {
  description = "API ECR repository URL."
  value       = aws_ecr_repository.this["api"].repository_url
}

output "worker_repository_url" {
  description = "Worker ECR repository URL."
  value       = aws_ecr_repository.this["worker"].repository_url
}

output "migration_repository_url" {
  description = "Migration ECR repository URL."
  value       = aws_ecr_repository.this["migration"].repository_url
}

output "scheduled_log_repository_url" {
  description = "Scheduled log ECR repository URL."
  value       = aws_ecr_repository.this["scheduled-log"].repository_url
}

output "firelens_repository_url" {
  description = "FireLens ECR repository URL."
  value       = aws_ecr_repository.this["firelens"].repository_url
}
