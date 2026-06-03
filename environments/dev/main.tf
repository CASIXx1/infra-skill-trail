module "network" {
  source = "../../modules/network"

  name     = local.name
  vpc_cidr = "10.20.0.0/16"
}

module "ecr" {
  source = "../../modules/ecr-data"

  name = local.name
}

module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  name = local.name
}

module "ecs_logs" {
  source = "../../modules/ecs-logs"

  name = local.name
}

module "ecs_iam" {
  source = "../../modules/ecs-iam"

  name              = local.name
  api_log_group_arn = module.ecs_logs.api_log_group_arn
}

module "security_groups" {
  source = "../../modules/security-groups"

  name   = local.name
  vpc_id = module.network.vpc_id
}

module "alb" {
  source = "../../modules/alb"

  name              = local.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
}

module "acm" {
  source = "../../modules/acm"

  domain_name      = var.api_domain_name
  hosted_zone_name = var.hosted_zone_name
}

module "dns" {
  source = "../../modules/dns"

  hosted_zone_name          = var.hosted_zone_name
  apex_domain_name          = var.apex_domain_name
  cloudfront_domain_name    = var.cloudfront_domain_name
  cloudfront_hosted_zone_id = var.cloudfront_hosted_zone_id
}
