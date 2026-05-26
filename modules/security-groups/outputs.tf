output "vpc_endpoint_security_group_id" {
  description = "Security group ID attached to interface VPC endpoints."
  value       = aws_security_group.vpc_endpoints.id
}
