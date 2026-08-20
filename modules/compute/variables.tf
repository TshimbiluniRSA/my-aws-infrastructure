variable "name" {
  description = "Prefix used to name compute resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the application server."
  type        = string
}

variable "ami_id" {
  description = "Explicit AMI ID for the EC2 instance. When null, the latest Amazon Linux 2023 x86_64 AMI is resolved from SSM."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.ami_id == null || can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "ami_id must be null or a valid AMI ID."
  }
}

variable "subnet_id" {
  description = "ID of the subnet in which to launch the EC2 instance."
  type        = string
}

variable "security_group_ids" {
  description = "VPC security group IDs to associate with the EC2 instance."
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) >= 1
    error_message = "At least one security group ID must be provided."
  }
}

variable "root_volume_size" {
  description = "Size in GiB of the EC2 root gp3 volume."
  type        = number
  default     = 16

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "The EC2 root volume size must be at least 8 GiB."
  }
}

variable "enable_detailed_monitoring" {
  description = "Whether EC2 detailed monitoring is enabled."
  type        = bool
  default     = false
}

variable "http_put_response_hop_limit" {
  description = "IMDS response hop limit for the EC2 instance."
  type        = number
  default     = 1

  validation {
    condition     = var.http_put_response_hop_limit >= 1 && var.http_put_response_hop_limit <= 64
    error_message = "http_put_response_hop_limit must be between 1 and 64."
  }
}

variable "application_directory" {
  description = "Base directory used to host the portfolio backend application."
  type        = string
  default     = "/opt/portfolio"

  validation {
    condition     = startswith(var.application_directory, "/")
    error_message = "application_directory must be an absolute path."
  }
}

variable "rds_secret_arn" {
  description = "ARN of the RDS-managed master credential secret the application may read."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the private S3 bucket used by the CV workflow."
  type        = string
}

variable "s3_public_cv_key" {
  description = "Object key of the permanent downloadable CV."
  type        = string

  validation {
    condition     = var.s3_public_cv_key != "" && !startswith(var.s3_public_cv_key, "/")
    error_message = "s3_public_cv_key must not be empty or begin with a slash."
  }
}

variable "s3_upload_prefix" {
  description = "Object key prefix for temporary visitor CV uploads."
  type        = string

  validation {
    condition = (
      var.s3_upload_prefix != "" &&
      !startswith(var.s3_upload_prefix, "/") &&
      !endswith(var.s3_upload_prefix, "/")
    )
    error_message = "s3_upload_prefix must not be empty or begin or end with a slash."
  }
}
