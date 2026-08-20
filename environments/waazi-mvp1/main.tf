data "terraform_remote_state" "portfolio" {
  backend = "s3"

  config = {
    bucket = "portfolio-infrastructure-tfstate-277052498943-eu-west-1-an"
    key    = "production/terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_security_group" "ec2" {
  name        = "waazi-mvp1-ec2-sg"
  description = "Public HTTP and HTTPS access for Waazi MVP 1"
  vpc_id      = data.terraform_remote_state.portfolio.outputs.vpc_id

  tags = {
    Name = "waazi-mvp1-ec2-sg"
    Tier = "application"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2.id
  description       = "Public HTTP"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_https" {
  security_group_id = aws_security_group.ec2.id
  description       = "Public HTTPS"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_ipv4" {
  security_group_id = aws_security_group.ec2.id
  description       = "Required application and management outbound access"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "rds" {
  name        = "waazi-mvp1-rds-sg"
  description = "Private PostgreSQL access for Waazi MVP 1"
  vpc_id      = data.terraform_remote_state.portfolio.outputs.vpc_id

  tags = {
    Name = "waazi-mvp1-rds-sg"
    Tier = "database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_postgresql_from_ec2" {
  security_group_id            = aws_security_group.rds.id
  description                  = "PostgreSQL from Waazi EC2 only"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.ec2.id
}

resource "aws_db_subnet_group" "this" {
  name       = "waazi-mvp1-rds-subnet-group"
  subnet_ids = data.terraform_remote_state.portfolio.outputs.private_subnet_ids

  tags = {
    Name = "waazi-mvp1-rds-subnet-group"
    Tier = "database"
  }
}

module "secrets" {
  source = "../../modules/secrets"

  secret_names = {
    django = "waazi-mvp1/django"
    openai = "waazi-mvp1/openai"
  }
}

module "database" {
  source = "../../modules/database"

  name        = "waazi-mvp1"
  environment = "mvp1"

  engine_version = var.postgres_engine_version
  instance_class = var.postgres_instance_class

  allocated_storage     = var.postgres_allocated_storage
  max_allocated_storage = var.postgres_max_allocated_storage
  database_name         = "waazi"
  master_username       = "waazi_admin"

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period   = var.postgres_backup_retention_period
  deletion_protection       = var.postgres_deletion_protection
  skip_final_snapshot       = var.postgres_skip_final_snapshot
  final_snapshot_identifier = "waazi-mvp1-postgres-final"
}

module "compute" {
  source = "../../modules/application_compute"

  name        = "waazi-mvp1"
  environment = "mvp1"

  ami_id                      = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = data.terraform_remote_state.portfolio.outputs.public_subnet_ids[0]
  security_group_ids          = [aws_security_group.ec2.id]
  root_volume_size            = var.ec2_root_volume_size
  application_directory       = "/opt/waazi"
  http_put_response_hop_limit = 1

  secret_arns = [
    module.database.master_user_secret_arn,
    module.secrets.secret_arns["django"],
    module.secrets.secret_arns["openai"],
  ]
}
