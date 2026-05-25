output "interface_endpoint_security_group_id" {
  description = "Security group ID attached to interface VPC endpoints."
  value       = aws_security_group.interface_endpoint.id
}

output "ecr_api_endpoint_id" {
  description = "ECR API VPC endpoint ID."
  value       = aws_vpc_endpoint.interface["ecr_api"].id
}

output "ecr_dkr_endpoint_id" {
  description = "ECR Docker registry VPC endpoint ID."
  value       = aws_vpc_endpoint.interface["ecr_dkr"].id
}

output "logs_endpoint_id" {
  description = "CloudWatch Logs VPC endpoint ID."
  value       = aws_vpc_endpoint.interface["logs"].id
}

output "s3_endpoint_id" {
  description = "S3 gateway VPC endpoint ID."
  value       = aws_vpc_endpoint.s3.id
}
