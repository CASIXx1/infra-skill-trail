output "subnet_group_name" {
  description = "DB subnet group name for Aurora."
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "Security group ID attached to Aurora."
  value       = aws_security_group.aurora.id
}
