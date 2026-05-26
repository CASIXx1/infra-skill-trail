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

output "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = module.ecs_iam.task_execution_role_arn
}

output "ecs_task_execution_role_name" {
  description = "ECS task execution role name."
  value       = module.ecs_iam.task_execution_role_name
}

output "ecs_task_role_arn" {
  description = "ECS task role ARN."
  value       = module.ecs_iam.task_role_arn
}

output "ecs_task_role_name" {
  description = "ECS task role name."
  value       = module.ecs_iam.task_role_name
}

output "vpc_endpoint_security_group_id" {
  description = "Security group ID attached to interface VPC endpoints."
  value       = module.security_groups.vpc_endpoint_security_group_id
}

output "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  value       = module.security_groups.ecs_task_security_group_id
}

output "ecs_private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks."
  value       = module.network.private_subnet_ids
}

output "api_ecs_service_name" {
  description = "ECS service name for the API service managed by ecspresso."
  value       = "${local.name}-api"
}

output "worker_ecs_service_name" {
  description = "ECS service name for the worker service managed by ecspresso."
  value       = "${local.name}-worker"
}

output "api_ecspresso_env" {
  description = "Environment values for the API service managed by ecspresso. TARGET_GROUP_ARN will be added after ALB target group is created."
  value = {
    ECS_CLUSTER_NAME        = module.ecs_cluster.cluster_name
    ECS_SERVICE_NAME        = "${local.name}-api"
    CONTAINER_NAME          = "app"
    CONTAINER_PORT          = "8080"
    TASK_EXECUTION_ROLE_ARN = module.ecs_iam.task_execution_role_arn
    TASK_ROLE_ARN           = module.ecs_iam.task_role_arn
    SUBNET_IDS              = join(",", module.network.private_subnet_ids)
    SECURITY_GROUP_IDS      = module.security_groups.ecs_task_security_group_id
    ASSIGN_PUBLIC_IP        = "false"
  }
}

output "worker_ecspresso_env" {
  description = "Environment values for the worker service managed by ecspresso."
  value = {
    ECS_CLUSTER_NAME        = module.ecs_cluster.cluster_name
    ECS_SERVICE_NAME        = "${local.name}-worker"
    CONTAINER_NAME          = "app"
    TASK_EXECUTION_ROLE_ARN = module.ecs_iam.task_execution_role_arn
    TASK_ROLE_ARN           = module.ecs_iam.task_role_arn
    SUBNET_IDS              = join(",", module.network.private_subnet_ids)
    SECURITY_GROUP_IDS      = module.security_groups.ecs_task_security_group_id
    ASSIGN_PUBLIC_IP        = "false"
  }
}
