resource "aws_scheduler_schedule" "scheduled_log" {
  name                = "${var.name}-scheduled-log"
  schedule_expression = var.schedule_expression
  state               = var.schedule_state

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.cluster_arn
    role_arn = aws_iam_role.this.arn

    ecs_parameters {
      task_definition_arn = aws_ecs_task_definition.bootstrap.arn_without_revision
      launch_type         = "FARGATE"
      task_count          = 1
      enable_execute_command = false

      network_configuration {
        subnets          = var.private_subnet_ids
        security_groups  = [var.security_group_id]
        assign_public_ip = false
      }
    }
  }
}
