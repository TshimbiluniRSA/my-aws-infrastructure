resource "aws_db_instance" "this" {
  identifier = "${var.name}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name                     = var.database_name
  username                    = var.master_username
  manage_master_user_password = true

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = false
  port                   = 5432

  multi_az = false

  backup_retention_period = var.backup_retention_period
  copy_tags_to_snapshot   = true

  auto_minor_version_upgrade = true
  apply_immediately          = var.apply_immediately

  performance_insights_enabled = false
  monitoring_interval          = 0

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    Name        = "${var.name}-postgres"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "database"
  }

  lifecycle {
    precondition {
      condition     = var.max_allocated_storage >= var.allocated_storage
      error_message = "max_allocated_storage must be greater than or equal to allocated_storage."
    }
  }
}
