output "api_ecr_repository_url" {
  description = "API ECR repository URL."
  value       = module.ecr.api_repository_url
}

output "worker_ecr_repository_url" {
  description = "Worker ECR repository URL."
  value       = module.ecr.worker_repository_url
}
