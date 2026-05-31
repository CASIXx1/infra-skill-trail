output "certificate_arn" {
  description = "ACM certificate ARN."
  value       = aws_acm_certificate.this.arn
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for DNS validation."
  value       = data.aws_route53_zone.this.zone_id
}
