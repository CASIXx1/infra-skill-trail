variable "name" {
  description = "Name prefix for worker resources."
  type        = string
}

variable "message_retention_seconds" {
  description = "Worker queue message retention period in seconds."
  type        = number
  default     = 345600
}

variable "visibility_timeout_seconds" {
  description = "Worker queue visibility timeout in seconds."
  type        = number
  default     = 30
}

variable "receive_wait_time_seconds" {
  description = "Worker queue long-poll wait time in seconds."
  type        = number
  default     = 20
}

variable "max_receive_count" {
  description = "Number of failed receives before moving a message to the DLQ."
  type        = number
  default     = 5
}

variable "api_task_role_name" {
  description = "API ECS task role name to attach worker queue send permissions to."
  type        = string
}
