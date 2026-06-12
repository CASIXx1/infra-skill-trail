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

module "container_registry" {
  source = "../../modules/container-registry"

  name = local.name
}

module "containers" {
  source = "../../modules/containers"

  name                               = local.name
  database_master_user_secret_arn    = module.database.master_user_secret_arn
  database_app_user_secret_arn       = module.database.app_user_secret_arn
  database_migration_user_secret_arn = module.database.migration_user_secret_arn
  cache_auth_token_secret_arn        = module.cache.auth_token_secret_arn
  external_service_secret_name       = var.external_service_secret_name
  ecr_repository_urls                = module.container_registry.repository_urls
  ecr_repository_arns                = module.container_registry.repository_arns
}

module "worker" {
  source = "../../modules/worker"

  name               = local.name
  api_task_role_name = module.containers.api_task_role_name
}

module "database" {
  source = "../../modules/database"

  name                       = local.name
  vpc_id                     = module.network.vpc_id
  database_subnet_ids        = module.network.database_subnet_ids
  ecs_task_security_group_id = module.network.ecs_task_security_group_id
}

module "cache" {
  source = "../../modules/cache"

  name                       = local.name
  vpc_id                     = module.network.vpc_id
  cache_subnet_ids           = module.network.cache_subnet_ids
  ecs_task_security_group_id = module.network.ecs_task_security_group_id
}

module "scheduler" {
  source = "../../modules/scheduler"

  name                    = local.name
  cluster_arn             = module.containers.cluster_arn
  private_subnet_ids      = module.network.private_subnet_ids
  security_group_id       = module.network.ecs_task_security_group_id
  task_role_arn           = module.containers.task_role_arn
  task_execution_role_arn = module.containers.task_execution_role_arn
  notification_email      = var.notification_email
  task_definitions = {
    scheduled-log = {
      family                    = "${local.name}-scheduled-log"
      job_name                  = "log_heartbeat"
      schedule_expression       = "rate(1 minute)"
      schedule_state            = var.scheduled_log_scheduler_state
      bootstrap_container_image = "public.ecr.aws/docker/library/busybox:stable"
    }
    scheduled-notification = {
      family                    = "${local.name}-scheduled-notification"
      job_name                  = "send_notification"
      schedule_expression       = "rate(1 day)"
      schedule_state            = var.scheduled_notification_scheduler_state
      bootstrap_container_image = "public.ecr.aws/docker/library/busybox:stable"
    }
  }
}

module "backend_deployment" {
  source = "../../modules/backend-deployment"

  role_name           = "github-actions-backend-skill-trail"
  github_repository   = "CASIXx1/backend-skill-trail"
  github_environment  = var.github_environment
  ecr_repository_arns = values(module.container_registry.repository_arns)
  log_group_names = [
    module.containers.api_log_group_name,
    module.containers.migration_log_group_name,
    module.containers.worker_log_group_name,
    module.containers.scheduled_log_log_group_name,
  ]
  ecs_task_role_arn = module.containers.task_role_arn
  additional_ecs_task_role_arns = [
    module.containers.api_task_role_arn,
    module.worker.task_role_arn,
  ]
  ecs_task_execution_role_arn = module.containers.task_execution_role_arn
  terraform_state_bucket      = var.terraform_state_bucket
  terraform_state_key         = var.terraform_state_key
}
