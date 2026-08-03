variable "aws_region" {
  description = "AWS region in which resources will be created."
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = var.aws_region == "eu-west-1"
    error_message = "The production environment is currently restricted to eu-west-1."
  }
}

variable "project_name" {
  description = "Name used to identify project resources."
  type        = string
  default     = "ai-powered-portfolio"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "production"
}

variable "postgres_engine_version" {
  description = "PostgreSQL engine version used by the production RDS instance."
  type        = string
  default     = "18.3"
}

variable "postgres_instance_class" {
  description = "RDS instance class for the production PostgreSQL database."
  type        = string
  default     = "db.t4g.micro"
}

variable "postgres_allocated_storage" {
  description = "Initial production PostgreSQL storage allocation in GiB."
  type        = number
  default     = 20
}

variable "postgres_max_allocated_storage" {
  description = "Maximum production PostgreSQL storage allocation in GiB for storage autoscaling."
  type        = number
  default     = 30
}

variable "postgres_database_name" {
  description = "Name of the initial production PostgreSQL database."
  type        = string
  default     = "portfolio"
}

variable "postgres_master_username" {
  description = "Master username for the production PostgreSQL database."
  type        = string
  default     = "portfolio_admin"
}

variable "postgres_backup_retention_period" {
  description = "Number of days to retain production PostgreSQL automated backups."
  type        = number
  default     = 7
}

variable "postgres_deletion_protection" {
  description = "Whether to protect the production PostgreSQL database from deletion."
  type        = bool
  default     = false
}

variable "postgres_skip_final_snapshot" {
  description = "Whether to skip a final snapshot when the production PostgreSQL database is deleted."
  type        = bool
  default     = true
}
