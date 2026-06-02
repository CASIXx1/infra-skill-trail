module "ecr" {
  source = "../../modules/ecr"

  name = local.name
}
