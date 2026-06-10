variable "name" {
  description = "Name prefix for cache resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ElastiCache is deployed."
  type        = string
}

variable "cache_subnet_ids" {
  description = "Subnet IDs for ElastiCache."
  type        = list(string)
}

variable "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  type        = string
}

variable "engine" {
  description = "ElastiCache engine."
  type        = string
  default     = "valkey"
}

variable "engine_version" {
  description = "ElastiCache engine version."
  type        = string
  default     = "8.0"
}

variable "node_type" {
  description = "ElastiCache node type."
  type        = string
  default     = "cache.t4g.micro"
}

variable "port" {
  description = "ElastiCache port."
  type        = number
  default     = 6379
}

variable "auth_token_secret_name" {
  description = "Secrets Manager secret name for the ElastiCache AUTH token."
  type        = string
  default     = "elasticache"
}
