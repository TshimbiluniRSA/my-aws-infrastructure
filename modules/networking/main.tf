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

resource "aws_db_subnet_group" "rds" {
  name        = "${var.name}-rds-subnet-group"
  description = "Private subnet group for the portfolio PostgreSQL RDS database"
  subnet_ids = [
    for availability_zone in var.availability_zones :
    aws_subnet.private[availability_zone].id
  ]

  tags = {
    Name        = "${var.name}-rds-subnet-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "database"
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.name}-ec2-sg"
  description = "Protects the portfolio application EC2 instance"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-ec2-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "application"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow public HTTP traffic to the portfolio application"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "ec2_https" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow public HTTPS traffic to the portfolio application"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_ipv4" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow all outbound IPv4 traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "Protects the private portfolio PostgreSQL RDS database"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-rds-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_postgresql_from_ec2" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ec2.id
  description                  = "Allow PostgreSQL traffic only from the application EC2 security group"

  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432
}

resource "aws_vpc_security_group_egress_rule" "rds_all_ipv4" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow all outbound IPv4 traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
