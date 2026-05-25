module "network" {
  source = "../../modules/network"

  name     = local.name
  vpc_cidr = "10.20.0.0/16"
}

module "ecr" {
  source = "../../modules/ecr"

  name = local.name
}

module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  name = local.name
}

module "ecs_iam" {
  source = "../../modules/ecs-iam"

  name = local.name
}
