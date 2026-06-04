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

  name = local.name
}

module "backend_deployment" {
  source = "../../modules/backend-deployment"

  role_name                   = "github-actions-backend-skill-trail"
  github_repository           = "CASIXx1/backend-skill-trail"
  github_environment          = var.github_environment
  ecr_repository_arns         = values(module.containers.repository_arns)
  api_ecr_repository_arn      = module.containers.repository_arns["api"]
  ecs_task_role_arn           = module.containers.task_role_arn
  ecs_task_execution_role_arn = module.containers.task_execution_role_arn
  terraform_state_bucket      = var.terraform_state_bucket
  terraform_state_key         = var.terraform_state_key
}
