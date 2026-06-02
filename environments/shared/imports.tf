import {
  to = module.ecr.aws_ecr_repository.this["api"]
  id = "infra-skill-trail-dev-api"
}

import {
  to = module.ecr.aws_ecr_repository.this["worker"]
  id = "infra-skill-trail-dev-worker"
}
