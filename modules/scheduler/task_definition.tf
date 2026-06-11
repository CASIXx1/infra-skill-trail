resource "aws_ecs_task_definition" "bootstrap" {
  for_each = var.task_definitions

  family                   = each.value.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "scheduled-log"
      image     = each.value.bootstrap_container_image
      essential = true
      command   = ["sh", "-c", "true"]
      versionConsistency = "enabled"
      environment = [
        {
          name  = "JOB_NAME"
          value = each.value.job_name
        },
        {
          name  = "SNS_TOPIC_ARN"
          value = aws_sns_topic.scheduled_notifications.arn
        },
        {
          name  = "SCHEDULE_NAME"
          value = "${var.name}-${each.key}"
        }
      ]
    }
  ])

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }
}
