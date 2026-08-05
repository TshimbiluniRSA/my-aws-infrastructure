output "bucket_id" {
  description = "ID of the private CV bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the private CV bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Name of the private CV bucket."
  value       = aws_s3_bucket.this.bucket
}

output "public_cv_key" {
  description = "Object key used for the permanent downloadable CV."
  value       = var.public_cv_key
}

output "upload_prefix" {
  description = "Object key prefix used for temporary visitor CV uploads."
  value       = var.upload_prefix
}
