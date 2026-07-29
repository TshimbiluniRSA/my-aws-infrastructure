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

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "public"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
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

resource "aws_route_table_association" "public" {
  for_each = local.subnets_by_availability_zone

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
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
