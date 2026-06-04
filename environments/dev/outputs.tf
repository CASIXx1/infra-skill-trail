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

output "github_actions_backend_role_arn" {
  description = "IAM role ARN assumed by backend-skill-trail GitHub Actions."
  value       = module.github_actions_backend_deploy_iam.role_arn
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
  value       = module.ecs_logs.api_log_group_name
}

output "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  value       = module.security_groups.ecs_task_security_group_id
}

output "alb_security_group_id" {
  description = "Security group ID attached to the public ALB."
  value       = module.security_groups.alb_security_group_id
}

output "alb_dns_name" {
  description = "Public ALB DNS name."
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Public ALB canonical hosted zone ID."
  value       = module.alb.alb_zone_id
}

output "api_target_group_arn" {
  description = "Target group ARN for the API ECS service managed by ecspresso."
  value       = module.alb.api_target_group_arn
}

output "api_domain_name" {
  description = "Public API domain name."
  value       = var.api_domain_name
}

output "api_acm_certificate_arn" {
  description = "ACM certificate ARN for the public API domain."
  value       = module.acm.certificate_arn
}

output "route53_hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  value       = module.acm.hosted_zone_id
}

output "route53_hosted_zone_name_servers" {
  description = "Name servers for the Route 53 hosted zone used by this project."
  value       = module.dns.hosted_zone_name_servers
}

output "apex_domain_name" {
  description = "Apex domain name for the existing CloudFront distribution."
  value       = module.dns.apex_domain_name
}

output "cloudfront_domain_name" {
  description = "Existing CloudFront distribution domain name for the apex domain."
  value       = module.dns.cloudfront_domain_name
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
    TARGET_GROUP_ARN        = module.alb.api_target_group_arn
    LOG_GROUP_NAME          = module.ecs_logs.api_log_group_name
    AWS_REGION              = var.aws_region
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
