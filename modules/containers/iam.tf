data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

locals {
  task_log_group_arns = [
    trimsuffix(aws_cloudwatch_log_group.api.arn, ":*"),
    trimsuffix(aws_cloudwatch_log_group.migration.arn, ":*"),
    trimsuffix(aws_cloudwatch_log_group.worker.arn, ":*"),
    trimsuffix(aws_cloudwatch_log_group.scheduled_log.arn, ":*"),
  ]
}

resource "aws_iam_role" "task_execution" {
  name               = "${var.name}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "${var.name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

resource "aws_iam_role" "api_task" {
  name               = "${var.name}-api-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

data "aws_iam_policy_document" "task_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      for log_group_arn in local.task_log_group_arns :
      "${log_group_arn}:log-stream:*"
    ]
  }

  statement {
    actions = [
      "logs:DescribeLogStreams",
    ]

    resources = local.task_log_group_arns
  }
}

resource "aws_iam_role_policy" "task_cloudwatch_logs" {
  name   = "${var.name}-ecs-task-cloudwatch-logs"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_cloudwatch_logs.json
}

resource "aws_iam_role_policy" "api_task_cloudwatch_logs" {
  name   = "${var.name}-api-ecs-task-cloudwatch-logs"
  role   = aws_iam_role.api_task.id
  policy = data.aws_iam_policy_document.task_cloudwatch_logs.json
}

data "aws_iam_policy_document" "task_execution_secrets_manager" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      var.database_master_user_secret_arn,
      var.database_app_user_secret_arn,
      var.database_migration_user_secret_arn,
      var.cache_auth_token_secret_arn,
      data.aws_secretsmanager_secret.external_service.arn,
    ]
  }
}

resource "aws_iam_role_policy" "task_execution_secrets_manager" {
  name   = "${var.name}-ecs-task-execution-secrets-manager"
  role   = aws_iam_role.task_execution.id
  policy = data.aws_iam_policy_document.task_execution_secrets_manager.json
}

data "aws_iam_policy_document" "task_execution_firelens_ecr_pull" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]

    resources = [
      var.ecr_repository_arns["firelens"],
    ]
  }
}

resource "aws_iam_role_policy" "task_execution_firelens_ecr_pull" {
  name   = "${var.name}-ecs-task-execution-firelens-ecr-pull"
  role   = aws_iam_role.task_execution.id
  policy = data.aws_iam_policy_document.task_execution_firelens_ecr_pull.json
}
