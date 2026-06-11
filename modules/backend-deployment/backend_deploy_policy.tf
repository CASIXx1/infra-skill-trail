data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  log_group_read_arns = [
    for log_group_name in var.log_group_names :
    "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${log_group_name}:*"
  ]
}

data "aws_iam_policy_document" "backend_deploy" {
  statement {
    sid = "EcrAuthorization"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    sid = "EcrPush"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]

    resources = var.ecr_repository_arns
  }

  statement {
    sid = "EcrManifestRead"

    actions = [
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
    ]

    resources = var.ecr_repository_arns
  }

  statement {
    sid = "EcspressoDeploy"

    actions = [
      "ecs:Describe*",
      "ecs:List*",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "ecs:CreateService",
    ]

    resources = ["*"]
  }

  statement {
    sid = "EcspressoRunTask"

    actions = [
      "ecs:RunTask",
      "ecs:DescribeTasks",
      "ecs:StopTask",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AlbRead"

    actions = [
      "elasticloadbalancing:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "CloudWatchLogsRead"

    actions = [
      "logs:GetLogEvents",
    ]

    resources = local.log_group_read_arns
  }

  statement {
    sid = "TerraformStateRead"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}/${var.terraform_state_key}",
    ]
  }

  statement {
    sid = "TerraformStateBucketLocation"

    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}",
    ]
  }

  statement {
    sid = "PassEcsTaskRoles"

    actions = [
      "iam:PassRole",
    ]

    resources = concat(
      [
        var.ecs_task_execution_role_arn,
        var.ecs_task_role_arn,
      ],
      var.additional_ecs_task_role_arns,
    )

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "backend_deploy" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.backend_deploy.json
}
