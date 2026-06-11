variable "name" {
  description = "Name prefix for scheduler resources."
  type        = string
}

variable "cluster_arn" {
  description = "ECS cluster ARN targeted by EventBridge Scheduler."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for scheduled ECS tasks."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID attached to scheduled ECS tasks."
  type        = string
}

variable "task_role_arn" {
  description = "ECS task role ARN passed to scheduled ECS tasks."
  type        = string
}

variable "task_execution_role_arn" {
  description = "ECS task execution role ARN passed to scheduled ECS tasks."
  type        = string
}

variable "task_definition_family" {
  description = "ECS task definition family registered by the backend deployment."
  type        = string
}

variable "bootstrap_container_image" {
  description = "Container image used only for the Terraform-managed bootstrap task definition revision."
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge Scheduler expression for launching the scheduled ECS task."
  type        = string
  default     = "rate(1 minute)"
}

variable "schedule_state" {
  description = "EventBridge Scheduler schedule state."
  type        = string
  default     = "DISABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.schedule_state)
    error_message = "schedule_state must be ENABLED or DISABLED."
  }
}
