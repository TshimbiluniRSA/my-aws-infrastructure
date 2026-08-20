variable "name" {
  description = "Prefix used to name application compute resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "ami_id" {
  description = "Explicit AMI ID. When null, the latest Amazon Linux 2023 x86_64 AMI is resolved from SSM."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.ami_id == null || can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "ami_id must be null or a valid AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Public subnet ID for the EC2 instance."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs for the EC2 instance."
  type        = list(string)
}

variable "root_volume_size" {
  description = "Root gp3 volume size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "application_directory" {
  description = "Application directory created during bootstrap."
  type        = string
  default     = "/opt/waazi"

  validation {
    condition     = startswith(var.application_directory, "/")
    error_message = "application_directory must be an absolute path."
  }
}

variable "secret_arns" {
  description = "Exact Secrets Manager ARNs the instance may read."
  type        = list(string)

  validation {
    condition     = length(var.secret_arns) > 0
    error_message = "At least one exact secret ARN is required."
  }
}

variable "enable_detailed_monitoring" {
  description = "Whether EC2 detailed monitoring is enabled."
  type        = bool
  default     = false
}

variable "http_put_response_hop_limit" {
  description = "IMDS response hop limit."
  type        = number
  default     = 1
}
