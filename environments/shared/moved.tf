moved {
  from = module.ecr.aws_ecr_repository.this["api"]
  to   = module.container_registry.aws_ecr_repository.this["api"]
}

moved {
  from = module.ecr.aws_ecr_repository.this["worker"]
  to   = module.container_registry.aws_ecr_repository.this["worker"]
}

moved {
  from = module.ecr.aws_ecr_lifecycle_policy.this["api"]
  to   = module.container_registry.aws_ecr_lifecycle_policy.this["api"]
}

moved {
  from = module.ecr.aws_ecr_lifecycle_policy.this["worker"]
  to   = module.container_registry.aws_ecr_lifecycle_policy.this["worker"]
}
