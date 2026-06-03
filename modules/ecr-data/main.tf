locals {
  repositories = toset(["api", "worker"])
}

data "aws_ecr_repository" "this" {
  for_each = local.repositories

  name = "${var.name}-${each.key}"
}
