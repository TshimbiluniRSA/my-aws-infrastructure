data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "networking" {
  source = "../../modules/networking"

  name        = "portfolio-production"
  environment = "production"
  vpc_cidr    = "10.0.0.0/16"
}
