data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  repositories = toset(["api", "worker"])

  repository_urls = {
    for repository in local.repositories :
    repository => "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${var.name}-${repository}"
  }
}
