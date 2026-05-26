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

module "security_groups" {
  source = "../../modules/security-groups"

  name           = local.name
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
}

module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  name                                 = local.name
  vpc_id                               = module.network.vpc_id
  private_subnet_ids                   = module.network.private_subnet_ids
  private_route_table_id               = module.network.private_route_table_id
  interface_endpoint_security_group_id = module.security_groups.vpc_endpoint_security_group_id
}
