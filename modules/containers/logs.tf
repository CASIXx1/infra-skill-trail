resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${var.name}/api"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "migration" {
  name              = "/ecs/${var.name}/migration"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "worker" {
  name              = "/ecs/${var.name}/worker"
  retention_in_days = var.retention_in_days
}
