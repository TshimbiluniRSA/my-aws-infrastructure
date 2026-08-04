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

variable "application_directory" {
  description = "Base directory used to host the portfolio backend application."
  type        = string
  default     = "/opt/portfolio"

  validation {
    condition     = startswith(var.application_directory, "/")
    error_message = "application_directory must be an absolute path."
  }
}
