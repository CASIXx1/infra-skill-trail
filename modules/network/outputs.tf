output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = aws_nat_gateway.this.id
}

output "nat_gateway_availability_mode" {
  description = "NAT Gateway availability mode."
  value       = aws_nat_gateway.this.availability_mode
}

output "public_1a_subnet_id" {
  description = "Public subnet ID in ap-northeast-1a."
  value       = aws_subnet.public_1a.id
}

output "public_1c_subnet_id" {
  description = "Public subnet ID in ap-northeast-1c."
  value       = aws_subnet.public_1c.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
}

output "private_1a_subnet_id" {
  description = "Private subnet ID in ap-northeast-1a."
  value       = aws_subnet.private_1a.id
}

output "private_1c_subnet_id" {
  description = "Private subnet ID in ap-northeast-1c."
  value       = aws_subnet.private_1c.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id
  ]
}

output "database_1a_subnet_id" {
  description = "Database subnet ID in ap-northeast-1a."
  value       = aws_subnet.database_1a.id
}

output "database_1c_subnet_id" {
  description = "Database subnet ID in ap-northeast-1c."
  value       = aws_subnet.database_1c.id
}

output "database_subnet_ids" {
  description = "Database subnet IDs."
  value = [
    aws_subnet.database_1a.id,
    aws_subnet.database_1c.id
  ]
}

output "cache_1a_subnet_id" {
  description = "Cache subnet ID in ap-northeast-1a."
  value       = aws_subnet.cache_1a.id
}

output "cache_1c_subnet_id" {
  description = "Cache subnet ID in ap-northeast-1c."
  value       = aws_subnet.cache_1c.id
}

output "cache_subnet_ids" {
  description = "Cache subnet IDs."
  value = [
    aws_subnet.cache_1a.id,
    aws_subnet.cache_1c.id
  ]
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID."
  value       = aws_route_table.private.id
}

output "database_route_table_id" {
  description = "Database route table ID."
  value       = aws_route_table.database.id
}

output "cache_route_table_id" {
  description = "Cache route table ID."
  value       = aws_route_table.cache.id
}

output "ecs_task_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  value       = aws_security_group.ecs_tasks.id
}

output "alb_arn" {
  description = "ALB ARN."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "ALB canonical hosted zone ID."
  value       = aws_lb.this.zone_id
}

output "alb_security_group_id" {
  description = "Security group ID attached to the public ALB."
  value       = aws_security_group.alb.id
}

output "api_target_group_arn" {
  description = "Target group ARN for the API ECS service."
  value       = aws_lb_target_group.api.arn
}

output "http_listener_arn" {
  description = "HTTP listener ARN."
  value       = aws_lb_listener.http.arn
}

output "api_certificate_arn" {
  description = "ACM certificate ARN for the public API domain."
  value       = aws_acm_certificate.api.arn
}

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
