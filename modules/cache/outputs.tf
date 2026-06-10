output "primary_endpoint" {
  description = "Primary endpoint address for ElastiCache."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint" {
  description = "Reader endpoint address for ElastiCache."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "port" {
  description = "ElastiCache port."
  value       = var.port
}

output "auth_token_secret_arn" {
  description = "Secrets Manager secret ARN containing the ElastiCache AUTH token."
  value       = aws_secretsmanager_secret.auth_token.arn
}

output "security_group_id" {
  description = "Security group ID attached to ElastiCache."
  value       = aws_security_group.this.id
}
