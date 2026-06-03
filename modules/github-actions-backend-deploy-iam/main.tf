resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
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
