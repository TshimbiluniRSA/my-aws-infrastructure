variable "name" {
  description = "Name used to identify networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 address range assigned to the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC subnets"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Exactly two distinct Availability Zones must be provided."
  }
}

variable "public_subnet_cidrs" {
  description = "IPv4 CIDR blocks assigned to public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2 && length(distinct(var.public_subnet_cidrs)) == 2
    error_message = "Exactly two distinct public subnet CIDR blocks must be provided."
  }
}

variable "private_subnet_cidrs" {
  description = "IPv4 CIDR blocks assigned to private subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == 2 && length(distinct(var.private_subnet_cidrs)) == 2
    error_message = "Exactly two distinct private subnet CIDR blocks must be provided."
  }
}
