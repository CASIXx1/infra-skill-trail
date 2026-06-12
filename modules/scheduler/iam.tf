data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  task_definition_arns = {
    for key, task_definition in var.task_definitions :
    key => "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:task-definition/${task_definition.family}"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-scheduler"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "ecs:RunTask",
    ]

    resources = [
      for task_definition_arn in values(local.task_definition_arns) :
      "${task_definition_arn}:*"
    ]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [var.cluster_arn]
    }
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    resources = [
      var.task_role_arn,
      var.task_execution_role_arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_sns_publish" {
  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      aws_sns_topic.scheduled_notifications.arn,
    ]
  }
}

resource "aws_iam_role_policy" "task_sns_publish" {
  name   = "${var.name}-scheduled-sns-publish"
  role   = split("/", var.task_role_arn)[1]
  policy = data.aws_iam_policy_document.task_sns_publish.json
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.name}-scheduler"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.this.json
}
