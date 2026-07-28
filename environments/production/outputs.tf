output "aws_account_id" {
  description = "AWS account used by this Terraform configuration."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region used by this Terraform configuration."
  value       = data.aws_region.current.name
}
