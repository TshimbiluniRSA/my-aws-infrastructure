output "aws_account_id" {
  description = "AWS account used by this Terraform configuration."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region used by this Terraform configuration."
  value       = data.aws_region.current.region
}

output "vpc_id" {
  description = "ID of the production VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the production public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the production private subnets"
  value       = module.networking.private_subnet_ids
}
