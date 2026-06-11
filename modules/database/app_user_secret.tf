resource "aws_secretsmanager_secret" "app_user" {
  name                    = "${var.name}/database/appuser"
  description             = "Application database user credentials for ${var.name}."
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_user" {
  secret_id = aws_secretsmanager_secret.app_user.id

  secret_string = jsonencode({
    username = var.app_username
    password = var.app_password
    engine   = "postgres"
    host     = aws_rds_cluster.this.endpoint
    port     = aws_rds_cluster.this.port
    dbname   = aws_rds_cluster.this.database_name
  })
}

resource "aws_secretsmanager_secret" "migration_user" {
  name                    = "${var.name}/database/migrationuser"
  description             = "Migration database user credentials for ${var.name}."
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "migration_user" {
  secret_id = aws_secretsmanager_secret.migration_user.id

  secret_string = jsonencode({
    username = var.migration_username
    password = var.migration_password
    engine   = "postgres"
    host     = aws_rds_cluster.this.endpoint
    port     = aws_rds_cluster.this.port
    dbname   = aws_rds_cluster.this.database_name
  })
}