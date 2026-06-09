output "api_ecr_repository_url" {
  description = "API ECR repository URL."
  value       = module.container_registry.api_repository_url
}

output "worker_ecr_repository_url" {
  description = "Worker ECR repository URL."
  value       = module.container_registry.worker_repository_url
}

output "migration_ecr_repository_url" {
  description = "Migration ECR repository URL."
  value       = module.container_registry.migration_repository_url
}

output "firelens_config_bucket_arn" {
  description = "S3 bucket ARN containing the FireLens Fluent Bit config."
  value       = module.firelens_config.bucket_arn
}

output "firelens_config_s3_arn" {
  description = "S3 object ARN for the FireLens Fluent Bit config."
  value       = module.firelens_config.config_s3_arn
}
