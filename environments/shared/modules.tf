module "container_registry" {
  source = "../../modules/container-registry"

  name = local.name
}
