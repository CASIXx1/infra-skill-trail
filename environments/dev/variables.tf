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
