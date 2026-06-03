output "repository_urls" {
  description = "ECR repository URLs keyed by workload name."
  value       = { for key, repository in data.aws_ecr_repository.this : key => repository.repository_url }
}

output "repository_arns" {
  description = "ECR repository ARNs keyed by workload name."
  value       = { for key, repository in data.aws_ecr_repository.this : key => repository.arn }
}

output "api_repository_url" {
  description = "API ECR repository URL."
  value       = data.aws_ecr_repository.this["api"].repository_url
}

output "worker_repository_url" {
  description = "Worker ECR repository URL."
  value       = data.aws_ecr_repository.this["worker"].repository_url
}
