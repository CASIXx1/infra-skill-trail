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

variable "external_service_secret_name" {
  description = "Name of the existing Secrets Manager secret containing external service keys."
  type        = string
}

variable "firelens_config_s3_arn" {
  description = "S3 object ARN for the FireLens Fluent Bit config."
  type        = string
}

variable "firelens_config_bucket_arn" {
  description = "S3 bucket ARN containing the FireLens Fluent Bit config."
  type        = string
}
