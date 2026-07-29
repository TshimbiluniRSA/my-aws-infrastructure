resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

locals {
  subnets_by_availability_zone = {
    for index, availability_zone in var.availability_zones : availability_zone => {
      public_cidr  = var.public_subnet_cidrs[index]
      private_cidr = var.private_subnet_cidrs[index]
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.subnets_by_availability_zone

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.public_cidr
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "public"
  }
}

resource "aws_subnet" "private" {
  for_each = local.subnets_by_availability_zone

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.private_cidr
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name}-private-${each.key}"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "private"
  }
}
