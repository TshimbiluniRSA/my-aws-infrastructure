terraform {
  backend "s3" {
    bucket       = "portfolio-infrastructure-tfstate-277052498943-eu-west-1-an"
    key          = "waazi-mvp1/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
