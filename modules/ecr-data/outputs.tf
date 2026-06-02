output "repository_urls" {
  description = "ECR repository URLs keyed by workload name."
  value       = local.repository_urls
}

output "api_repository_url" {
  description = "API ECR repository URL."
  value       = local.repository_urls["api"]
}

output "worker_repository_url" {
  description = "Worker ECR repository URL."
  value       = local.repository_urls["worker"]
}
