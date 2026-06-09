data "aws_secretsmanager_secret" "external_service" {
  name = var.external_service_secret_name
}

locals {
  new_relic_firelens_image = "533243300146.dkr.ecr.ap-northeast-1.amazonaws.com/newrelic/logging-firelens-fluentbit:1.17.1"
}
