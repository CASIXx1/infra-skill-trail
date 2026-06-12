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

variable "task_definitions" {
  description = "Scheduled job task definitions keyed by job key."
  type = map(object({
    family                   = string
    job_name                 = string
    schedule_expression      = string
    schedule_state           = string
    bootstrap_container_image = string
  }))

  validation {
    condition = alltrue([
      for task_definition in values(var.task_definitions) :
      contains(["ENABLED", "DISABLED"], task_definition.schedule_state)
    ])
    error_message = "Each task definition schedule_state must be ENABLED or DISABLED."
  }
}

variable "notification_email" {
  description = "Email address subscribed to scheduled notification SNS messages."
  type        = string
}
