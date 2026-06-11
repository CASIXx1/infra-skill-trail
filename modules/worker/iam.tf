data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task" {
  name               = "${var.name}-worker-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_worker_sqs" {
  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
    ]

    resources = [
      aws_sqs_queue.worker.arn,
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_worker_sqs" {
  name   = "${var.name}-ecs-task-worker-sqs"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.ecs_task_worker_sqs.json
}

data "aws_iam_policy_document" "api_task_worker_sqs" {
  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessage",
    ]

    resources = [
      aws_sqs_queue.worker.arn,
    ]
  }
}

resource "aws_iam_role_policy" "api_task_worker_sqs" {
  name   = "${var.name}-api-ecs-task-worker-sqs"
  role   = var.api_task_role_name
  policy = data.aws_iam_policy_document.api_task_worker_sqs.json
}
