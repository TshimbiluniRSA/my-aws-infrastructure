variable "aws_region" {
  description = "AWS region for Waazi MVP 1."
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = var.aws_region == "eu-west-1"
    error_message = "Waazi MVP 1 is restricted to eu-west-1."
  }
}

variable "ec2_instance_type" {
  description = "Waazi application EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ec2_root_volume_size" {
  description = "Waazi EC2 root gp3 volume size in GiB."
  type        = number
  default     = 20
}

variable "ec2_ami_id" {
  description = "Optional explicit Waazi AMI. Null resolves the current Amazon Linux 2023 AMI for initial creation."
  type        = string
  default     = null
  sensitive   = true
}

variable "postgres_engine_version" {
  description = "PostgreSQL 16 version verified as available in eu-west-1."
  type        = string
  default     = "16.14"
}

variable "postgres_instance_class" {
  description = "Waazi PostgreSQL instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "postgres_allocated_storage" {
  description = "Initial Waazi PostgreSQL gp3 storage in GiB."
  type        = number
  default     = 20
}

variable "postgres_max_allocated_storage" {
  description = "Maximum Waazi PostgreSQL storage in GiB."
  type        = number
  default     = 30
}

variable "postgres_backup_retention_period" {
  description = "Automated backup retention in days."
  type        = number
  default     = 7
}

variable "postgres_deletion_protection" {
  description = "Protect Waazi PostgreSQL from deletion."
  type        = bool
  default     = true
}

variable "postgres_skip_final_snapshot" {
  description = "Whether to skip a final snapshot when Waazi PostgreSQL is destroyed."
  type        = bool
  default     = false
}
