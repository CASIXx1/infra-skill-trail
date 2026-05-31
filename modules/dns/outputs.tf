output "hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  value       = data.aws_route53_zone.this.zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the Route 53 hosted zone."
  value       = data.aws_route53_zone.this.name_servers
}

output "apex_domain_name" {
  description = "Apex domain name."
  value       = var.apex_domain_name
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name for the apex domain."
  value       = var.cloudfront_domain_name
}
