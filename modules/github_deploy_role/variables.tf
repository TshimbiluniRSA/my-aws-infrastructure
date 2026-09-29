variable "role_name" {
  description = "Name of the IAM role assumed by the GitHub Actions deploy workflow."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the role, in owner/name form."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+/[A-Za-z0-9._-]+$", var.github_repository))
    error_message = "github_repository must be in owner/name form."
  }
}

variable "github_branch" {
  description = "Branch whose workflow runs may assume the role."
  type        = string
  default     = "main"
}

variable "instance_arn" {
  description = "ARN of the EC2 instance the role may send Run Command deployments to."
  type        = string
}
