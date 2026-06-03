variable "aws_region" {
  description = "AWS region for shared resources."
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
  description = "Environment name used in shared ECR repository names."
  type        = string
  default     = "dev"
}
