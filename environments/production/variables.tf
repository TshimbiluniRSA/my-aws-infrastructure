variable "aws_region" {
  description = "AWS region in which resources will be created."
  type        = string
  default     = "eu-west-1"
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
