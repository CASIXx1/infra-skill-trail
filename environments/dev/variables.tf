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
