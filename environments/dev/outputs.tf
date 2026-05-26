output "vpc_id" {
  description = "Created VPC ID."
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "Created VPC CIDR block."
  value       = module.network.vpc_cidr_block
}
