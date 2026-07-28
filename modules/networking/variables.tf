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
