variable "bucket_name_prefix" {
  description = "Predictable prefix used to name the S3 bucket."
  type        = string

  validation {
    condition = (
      length(var.bucket_name_prefix) >= 3 &&
      length(var.bucket_name_prefix) <= 50 &&
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name_prefix))
    )
    error_message = "bucket_name_prefix must be 3-50 characters of lowercase letters, numbers, or hyphens, and must begin and end with a letter or number."
  }
}

variable "aws_account_id" {
  description = "AWS account ID used as the deterministic bucket-name suffix."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "force_destroy" {
  description = "Whether Terraform may delete the bucket while it contains objects."
  type        = bool
  default     = false
}

variable "public_cv_key" {
  description = "Object key used for the permanent downloadable CV."
  type        = string
  default     = "cv/public/tshimbiluni-nedambale-cv.pdf"

  validation {
    condition     = var.public_cv_key != "" && !startswith(var.public_cv_key, "/")
    error_message = "public_cv_key must not be empty or begin with a slash."
  }
}

variable "upload_prefix" {
  description = "Object key prefix used for temporary visitor CV uploads."
  type        = string
  default     = "cv/uploads"

  validation {
    condition = (
      var.upload_prefix != "" &&
      !startswith(var.upload_prefix, "/") &&
      !endswith(var.upload_prefix, "/")
    )
    error_message = "upload_prefix must not be empty or begin or end with a slash."
  }
}
