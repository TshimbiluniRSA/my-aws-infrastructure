data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "networking" {
  source = "../../modules/networking"

  name        = "portfolio-production"
  environment = "production"
  vpc_cidr    = "10.0.0.0/16"

  availability_zones = [
    "eu-west-1a",
    "eu-west-1b",
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]
}

module "database" {
  source = "../../modules/database"

  name        = "portfolio-production"
  environment = var.environment

  engine_version = var.postgres_engine_version
  instance_class = var.postgres_instance_class

  allocated_storage     = var.postgres_allocated_storage
  max_allocated_storage = var.postgres_max_allocated_storage

  database_name   = var.postgres_database_name
  master_username = var.postgres_master_username

  db_subnet_group_name = module.networking.rds_db_subnet_group_name
  vpc_security_group_ids = [
    module.networking.rds_security_group_id,
  ]

  backup_retention_period = var.postgres_backup_retention_period
  deletion_protection     = var.postgres_deletion_protection
  skip_final_snapshot     = var.postgres_skip_final_snapshot
}
