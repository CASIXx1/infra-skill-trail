module "network" {
  source = "../../modules/network"

  name     = local.name
  vpc_cidr = "10.20.0.0/16"
}
