resource "random_password" "auth_token" {
  length           = 32
  special          = true
  override_special = "!&#$^<>-"
}

resource "aws_secretsmanager_secret" "auth_token" {
  name                    = var.auth_token_secret_name
  description             = "ElastiCache AUTH token for ${var.name}."
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "auth_token" {
  secret_id = aws_secretsmanager_secret.auth_token.id

  secret_string = jsonencode({
    AUTH_TOKEN = random_password.auth_token.result
  })
}
