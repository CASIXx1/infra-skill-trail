module "container_registry" {
  source = "../../modules/container-registry"

  name = local.name
}

module "firelens_config" {
  source = "../../modules/firelens-config"

  name = local.name
}
