variable "name" {
  description = "Prefix used to name database resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version supported by RDS in the target AWS region."
  type        = string
}

variable "instance_class" {
  description = "RDS database instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial database storage allocation in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum database storage allocation in GiB for storage autoscaling."
  type        = number
  default     = 30
}

variable "database_name" {
  description = "Name of the initial PostgreSQL database."
  type        = string
  default     = "portfolio"
}

variable "master_username" {
  description = "Master username for the PostgreSQL database."
  type        = string
  default     = "portfolio_admin"
}

variable "db_subnet_group_name" {
  description = "Name of the RDS DB subnet group."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs to associate with the database."
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to protect the database from deletion."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip creating a final snapshot when the database is deleted."
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Identifier for the final snapshot when skip_final_snapshot is false."
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Whether database modifications are applied immediately instead of during the maintenance window."
  type        = bool
  default     = false
}
