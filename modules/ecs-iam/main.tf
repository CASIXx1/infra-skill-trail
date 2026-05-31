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
  api_log_group_arn = trimsuffix(var.api_log_group_arn, ":*")
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

data "aws_iam_policy_document" "task_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${local.api_log_group_arn}:log-stream:*"]
  }

  statement {
    actions = [
      "logs:DescribeLogStreams",
    ]

    resources = [local.api_log_group_arn]
  }
}

resource "aws_iam_role_policy" "task_cloudwatch_logs" {
  name   = "${var.name}-ecs-task-cloudwatch-logs"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_cloudwatch_logs.json
}
