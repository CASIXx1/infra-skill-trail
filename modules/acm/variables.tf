variable "domain_name" {
  description = "Domain name for the ACM certificate."
  type        = string
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name used for DNS validation."
  type        = string
}
