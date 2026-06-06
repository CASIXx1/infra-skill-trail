variable "name" {
  description = "Name prefix for database resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "database_subnet_ids" {
  description = "Subnet IDs for Aurora database instances."
  type        = list(string)
}

variable "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks allowed to connect to Aurora."
  type        = string
}
