locals {
  repositories = toset(["api", "worker", "migration"])
}

data "aws_ecr_repository" "this" {
  for_each = local.repositories

  name = "${var.name}-${each.key}"
}
