output "vpc_endpoint_security_group_id" {
  description = "Security group ID attached to interface VPC endpoints."
  value       = aws_security_group.vpc_endpoints.id
}

output "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  value       = aws_security_group.ecs_tasks.id
}

output "alb_security_group_id" {
  description = "Security group ID attached to the public ALB."
  value       = aws_security_group.alb.id
}
