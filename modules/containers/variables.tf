variable "name" {
  description = "Name prefix for container runtime resources."
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch Logs retention period in days."
  type        = number
  default     = 30
}

variable "database_master_user_secret_arn" {
  description = "Secrets Manager secret ARN for the RDS-managed database master user credentials."
  type        = string
}

variable "database_app_user_secret_arn" {
  description = "Secrets Manager secret ARN for the application database user credentials."
  type        = string
}

variable "database_migration_user_secret_arn" {
  description = "Secrets Manager secret ARN for the migration database user credentials."
  type        = string
}

variable "cache_auth_token_secret_arn" {
  description = "Secrets Manager secret ARN for the ElastiCache AUTH token."
  type        = string
}

variable "external_service_secret_name" {
  description = "Name of the existing Secrets Manager secret containing external service keys."
  type        = string
}

variable "ecr_repository_urls" {
  description = "ECR repository URLs keyed by workload name."
  type        = map(string)
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs keyed by workload name."
  type        = map(string)
}
