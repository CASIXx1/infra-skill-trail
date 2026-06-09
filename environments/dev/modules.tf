module "network" {
  source = "../../modules/network"

  name                      = local.name
  vpc_cidr                  = "10.20.0.0/16"
  api_domain_name           = var.api_domain_name
  hosted_zone_name          = var.hosted_zone_name
  apex_domain_name          = var.apex_domain_name
  cloudfront_domain_name    = var.cloudfront_domain_name
  cloudfront_hosted_zone_id = var.cloudfront_hosted_zone_id
}

module "containers" {
  source = "../../modules/containers"

  name                            = local.name
  database_master_user_secret_arn = module.database.master_user_secret_arn
  external_service_secret_name    = var.external_service_secret_name
  firelens_config_bucket_arn      = data.terraform_remote_state.shared.outputs.firelens_config_bucket_arn
  firelens_config_s3_arn          = data.terraform_remote_state.shared.outputs.firelens_config_s3_arn
}

module "database" {
  source = "../../modules/database"

  name                       = local.name
  vpc_id                     = module.network.vpc_id
  database_subnet_ids        = module.network.database_subnet_ids
  ecs_task_security_group_id = module.network.ecs_task_security_group_id
}

module "backend_deployment" {
  source = "../../modules/backend-deployment"

  role_name                   = "github-actions-backend-skill-trail"
  github_repository           = "CASIXx1/backend-skill-trail"
  github_environment          = var.github_environment
  ecr_repository_arns         = values(module.containers.repository_arns)
  ecs_task_role_arn           = module.containers.task_role_arn
  ecs_task_execution_role_arn = module.containers.task_execution_role_arn
  terraform_state_bucket      = var.terraform_state_bucket
  terraform_state_key         = var.terraform_state_key
}
