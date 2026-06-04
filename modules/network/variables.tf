variable "name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
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
  description = "Apex domain name."
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name for the apex domain."
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront canonical hosted zone ID."
  type        = string
}
