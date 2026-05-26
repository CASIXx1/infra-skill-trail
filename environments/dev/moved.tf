moved {
  from = module.vpc_endpoints.aws_security_group.interface_endpoint
  to   = module.security_groups.aws_security_group.vpc_endpoints
}
