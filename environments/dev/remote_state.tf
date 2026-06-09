data "terraform_remote_state" "shared" {
  backend = "s3"

  config = local.shared_terraform_state_config
}

locals {
  shared_terraform_state_config = merge(
    {
      bucket       = var.terraform_state_bucket
      key          = var.shared_terraform_state_key
      region       = var.aws_region
      use_lockfile = true
    },
    var.aws_profile == null ? {} : {
      profile = var.aws_profile
    }
  )
}
