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

variable "database_name" {
  description = "Initial database name."
  type        = string
  default     = "app"
}

variable "master_username" {
  description = "Master username for Aurora PostgreSQL."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Aurora PostgreSQL engine version."
  type        = string
  default     = "17.9"
}

variable "instance_class" {
  description = "Aurora PostgreSQL instance class."
  type        = string
  default     = "db.t4g.medium"
}

variable "backup_retention_period" {
  description = "Backup retention period in days."
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the Aurora cluster."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot when deleting the Aurora cluster."
  type        = bool
  default     = true
}
