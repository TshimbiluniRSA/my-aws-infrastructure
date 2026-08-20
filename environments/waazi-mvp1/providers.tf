provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "waazi"
      Environment = "mvp1"
      ManagedBy   = "Terraform"
      Owner       = "Tshimbiluni"
    }
  }
}
