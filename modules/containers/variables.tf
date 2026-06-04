variable "name" {
  description = "Name prefix for container runtime resources."
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch Logs retention period in days."
  type        = number
  default     = 30
}
