output "subnet_group_name" {
  description = "DB subnet group name for Aurora."
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "Security group ID attached to Aurora."
  value       = aws_security_group.aurora.id
}

output "cluster_arn" {
  description = "Aurora cluster ARN."
  value       = aws_rds_cluster.this.arn
}

output "cluster_identifier" {
  description = "Aurora cluster identifier."
  value       = aws_rds_cluster.this.cluster_identifier
}

output "writer_endpoint" {
  description = "Aurora writer endpoint."
  value       = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "Aurora reader endpoint."
  value       = aws_rds_cluster.this.reader_endpoint
}

output "port" {
  description = "Aurora PostgreSQL port."
  value       = aws_rds_cluster.this.port
}

output "database_name" {
  description = "Initial database name."
  value       = aws_rds_cluster.this.database_name
}

output "master_user_secret_arn" {
  description = "Secrets Manager secret ARN for the RDS-managed master user credentials."
  value       = aws_rds_cluster.this.master_user_secret[0].secret_arn
}
