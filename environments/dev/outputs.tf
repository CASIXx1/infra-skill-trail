output "vpc_id" {
  description = "Created VPC ID."
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "Created VPC CIDR block."
  value       = module.network.vpc_cidr_block
}

output "repository_urls" {
  description = "ECR repository URLs keyed by workload name."
  value       = module.container_registry.repository_urls
}

output "api_ecr_repository_url" {
  description = "API ECR repository URL."
  value       = module.containers.api_repository_url
}

output "worker_ecr_repository_url" {
  description = "Worker ECR repository URL."
  value       = module.containers.worker_repository_url
}

output "migration_ecr_repository_url" {
  description = "Migration ECR repository URL."
  value       = module.containers.migration_repository_url
}

output "firelens_ecr_repository_url" {
  description = "FireLens ECR repository URL."
  value       = module.containers.firelens_repository_url
}

output "github_actions_backend_role_arn" {
  description = "IAM role ARN assumed by backend-skill-trail GitHub Actions."
  value       = module.backend_deployment.role_arn
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.containers.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN."
  value       = module.containers.cluster_arn
}

output "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = module.containers.task_execution_role_arn
}

output "ecs_task_execution_role_name" {
  description = "ECS task execution role name."
  value       = module.containers.task_execution_role_name
}

output "ecs_task_role_arn" {
  description = "ECS task role ARN."
  value       = module.containers.task_role_arn
}

output "ecs_task_role_name" {
  description = "ECS task role name."
  value       = module.containers.task_role_name
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = module.network.nat_gateway_id
}

output "nat_gateway_availability_mode" {
  description = "NAT Gateway availability mode."
  value       = module.network.nat_gateway_availability_mode
}

output "api_log_group_name" {
  description = "CloudWatch Logs log group name for the API ECS service."
  value       = module.containers.api_log_group_name
}

output "migration_log_group_name" {
  description = "CloudWatch Logs log group name for migration tasks."
  value       = module.containers.migration_log_group_name
}

output "external_service_secret_arn" {
  description = "Secrets Manager secret ARN for external service keys."
  value       = module.containers.external_service_secret_arn
}

output "new_relic_license_key_secret_arn" {
  description = "Secrets Manager secret ARN for the New Relic license key."
  value       = module.containers.new_relic_license_key_secret_arn
}

output "new_relic_firelens_image" {
  description = "New Relic FireLens Fluent Bit image."
  value       = module.containers.new_relic_firelens_image
}

output "new_relic_log_endpoint" {
  description = "New Relic Logs endpoint for the JP region."
  value       = "https://log-api.jp.nr-data.net/log/v1"
}

output "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  value       = module.network.ecs_task_security_group_id
}

output "database_subnet_group_name" {
  description = "DB subnet group name for Aurora."
  value       = module.database.subnet_group_name
}

output "database_security_group_id" {
  description = "Security group ID attached to Aurora."
  value       = module.database.security_group_id
}

output "database_cluster_arn" {
  description = "Aurora cluster ARN."
  value       = module.database.cluster_arn
}

output "database_cluster_identifier" {
  description = "Aurora cluster identifier."
  value       = module.database.cluster_identifier
}

output "database_writer_endpoint" {
  description = "Aurora writer endpoint."
  value       = module.database.writer_endpoint
}

output "database_reader_endpoint" {
  description = "Aurora reader endpoint."
  value       = module.database.reader_endpoint
}

output "database_port" {
  description = "Aurora PostgreSQL port."
  value       = module.database.port
}

output "database_name" {
  description = "Initial database name."
  value       = module.database.database_name
}

output "database_master_user_secret_arn" {
  description = "Secrets Manager secret ARN for the RDS-managed master user credentials."
  value       = module.database.master_user_secret_arn
}

output "alb_security_group_id" {
  description = "Security group ID attached to the public ALB."
  value       = module.network.alb_security_group_id
}

output "alb_dns_name" {
  description = "Public ALB DNS name."
  value       = module.network.alb_dns_name
}

output "alb_zone_id" {
  description = "Public ALB canonical hosted zone ID."
  value       = module.network.alb_zone_id
}

output "api_target_group_arn" {
  description = "Target group ARN for the API ECS service managed by ecspresso."
  value       = module.network.api_target_group_arn
}

output "api_domain_name" {
  description = "Public API domain name."
  value       = var.api_domain_name
}

output "api_acm_certificate_arn" {
  description = "ACM certificate ARN for the public API domain."
  value       = module.network.api_certificate_arn
}

output "route53_hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  value       = module.network.hosted_zone_id
}

output "route53_hosted_zone_name_servers" {
  description = "Name servers for the Route 53 hosted zone used by this project."
  value       = module.network.hosted_zone_name_servers
}

output "apex_domain_name" {
  description = "Apex domain name for the existing CloudFront distribution."
  value       = module.network.apex_domain_name
}

output "cloudfront_domain_name" {
  description = "Existing CloudFront distribution domain name for the apex domain."
  value       = module.network.cloudfront_domain_name
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

output "migration_container_name" {
  description = "Container name for migration tasks managed by ecspresso."
  value       = "migration"
}

output "migration_ecspresso_env" {
  description = "Environment values for migration tasks managed by ecspresso."
  value = {
    ECS_CLUSTER_NAME             = module.containers.cluster_name
    CONTAINER_NAME               = "migration"
    TASK_EXECUTION_ROLE_ARN      = module.containers.task_execution_role_arn
    TASK_ROLE_ARN                = module.containers.task_role_arn
    SUBNET_IDS                   = join(",", module.network.private_subnet_ids)
    SECURITY_GROUP_IDS           = module.network.ecs_task_security_group_id
    ASSIGN_PUBLIC_IP             = "false"
    MIGRATION_ECR_REPOSITORY_URL = module.containers.migration_repository_url
    LOG_GROUP_NAME               = module.containers.migration_log_group_name
    AWS_REGION                   = var.aws_region
    DB_HOST                      = module.database.writer_endpoint
    DB_READER_HOST               = module.database.reader_endpoint
    DB_PORT                      = tostring(module.database.port)
    DB_NAME                      = module.database.database_name
    DB_MASTER_USER_SECRET_ARN    = module.database.master_user_secret_arn
  }
}
