variable "name" {
  description = "Name prefix for ECS IAM resources."
  type        = string
}

variable "api_log_group_arn" {
  description = "CloudWatch Logs log group ARN for the API ECS service."
  type        = string
}
