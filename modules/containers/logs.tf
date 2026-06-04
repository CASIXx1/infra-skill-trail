resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${var.name}/api"
  retention_in_days = var.retention_in_days
}
