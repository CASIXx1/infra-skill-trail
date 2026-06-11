variable "aws_region" {
  description = "AWS region for dev resources."
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used by the AWS provider. Set null to use the default AWS credential chain."
  type        = string
  default     = null
}

variable "project" {
  description = "Project name used for resource names and tags."
  type        = string
  default     = "infra-skill-trail"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "github_environment" {
  description = "GitHub Environment allowed to assume the backend deploy role."
  type        = string
  default     = "dev"
}

variable "scheduled_log_scheduler_state" {
  description = "EventBridge Scheduler state for the scheduled-log task."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.scheduled_log_scheduler_state)
    error_message = "scheduled_log_scheduler_state must be ENABLED or DISABLED."
  }
}

variable "scheduled_notification_scheduler_state" {
  description = "EventBridge Scheduler state for the scheduled notification task."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.scheduled_notification_scheduler_state)
    error_message = "scheduled_notification_scheduler_state must be ENABLED or DISABLED."
  }
}

variable "notification_email" {
  description = "Email address subscribed to scheduled notification SNS messages."
  type        = string
}

variable "external_service_secret_name" {
  description = "Name of the existing Secrets Manager secret containing external service keys."
  type        = string
}

variable "api_domain_name" {
  description = "Public API domain name."
  type        = string
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name."
  type        = string
}

variable "apex_domain_name" {
  description = "Apex domain name for the existing CloudFront distribution."
  type        = string
}

variable "cloudfront_domain_name" {
  description = "Existing CloudFront distribution domain name for the apex domain."
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront canonical hosted zone ID."
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket containing the dev Terraform state read by backend deploy workflows."
  type        = string
}

variable "terraform_state_key" {
  description = "S3 object key for the dev Terraform state read by backend deploy workflows."
  type        = string
}
