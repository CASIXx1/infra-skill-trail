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
    ]

    resources = [
      var.api_ecr_repository_arn,
    ]
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

    resources = [
      var.ecs_task_role_arn,
      var.ecs_task_execution_role_arn,
    ]

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
