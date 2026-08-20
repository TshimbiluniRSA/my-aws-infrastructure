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

variable "ec2_instance_type" {
  description = "Instance type used by the production portfolio backend server."
  type        = string
  default     = "t3.micro"
}

variable "ec2_ami_id" {
  description = "AMI ID pinned to the currently deployed production Portfolio EC2 instance."
  type        = string
  default     = "ami-062a8901a5ddcf280"
  sensitive   = true

  validation {
    condition     = can(regex("^ami-[0-9a-f]+$", var.ec2_ami_id))
    error_message = "ec2_ami_id must be a valid AMI ID."
  }
}

variable "ec2_root_volume_size" {
  description = "Size in GiB of the EC2 root gp3 volume."
  type        = number
  default     = 16
}

variable "ec2_enable_detailed_monitoring" {
  description = "Whether EC2 detailed monitoring is enabled."
  type        = bool
  default     = false
}

variable "ec2_http_put_response_hop_limit" {
  description = "IMDS response hop limit matching the currently deployed production Portfolio EC2 instance."
  type        = number
  default     = 2

  validation {
    condition     = var.ec2_http_put_response_hop_limit >= 1 && var.ec2_http_put_response_hop_limit <= 64
    error_message = "ec2_http_put_response_hop_limit must be between 1 and 64."
  }
}

variable "cv_bucket_name_prefix" {
  description = "Globally unique prefix used for the private portfolio CV bucket."
  type        = string
  default     = "tshimbiluni-portfolio-cv-production"
}

variable "cv_bucket_force_destroy" {
  description = "Whether Terraform may delete the CV bucket while it contains objects."
  type        = bool
  default     = false
}

variable "cv_public_key" {
  description = "S3 object key used for the permanent downloadable CV."
  type        = string
  default     = "cv/public/tshimbiluni-nedambale-cv.pdf"
}

variable "cv_upload_prefix" {
  description = "S3 prefix used for temporary visitor CV uploads."
  type        = string
  default     = "cv/uploads"
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
  description = "Number of days to retain automated PostgreSQL backups."
  type        = number
  default     = 1

  validation {
    condition = (
      var.postgres_backup_retention_period >= 1 &&
      var.postgres_backup_retention_period <= 35
    )
    error_message = "PostgreSQL backup retention must be between 1 and 35 days."
  }
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
