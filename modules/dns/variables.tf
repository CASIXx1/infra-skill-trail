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
