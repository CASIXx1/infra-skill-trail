output "vpc_id" {
  description = "Created VPC ID."
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "Created VPC CIDR block."
  value       = module.network.vpc_cidr_block
}

output "api_ecr_repository_url" {
  description = "API ECR repository URL."
  value       = module.ecr.api_repository_url
}

output "worker_ecr_repository_url" {
  description = "Worker ECR repository URL."
  value       = module.ecr.worker_repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs_cluster.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN."
  value       = module.ecs_cluster.cluster_arn
}
