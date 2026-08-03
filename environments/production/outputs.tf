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

output "internet_gateway_id" {
  description = "ID of the production Internet Gateway"
  value       = module.networking.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the production public route table"
  value       = module.networking.public_route_table_id
}

output "public_subnet_ids" {
  description = "IDs of the production public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the production private subnets"
  value       = module.networking.private_subnet_ids
}

output "rds_db_subnet_group_name" {
  description = "Name of the DB subnet group for the private PostgreSQL RDS database"
  value       = module.networking.rds_db_subnet_group_name
}

output "ec2_security_group_id" {
  description = "ID of the production application EC2 security group"
  value       = module.networking.ec2_security_group_id
}

output "rds_security_group_id" {
  description = "ID of the production PostgreSQL RDS security group"
  value       = module.networking.rds_security_group_id
}

output "postgres_endpoint" {
  description = "Connection endpoint for the production PostgreSQL database, including the port."
  value       = module.database.db_endpoint
}

output "postgres_address" {
  description = "DNS address of the production PostgreSQL database."
  value       = module.database.db_address
}

output "postgres_port" {
  description = "Port on which the production PostgreSQL database accepts connections."
  value       = module.database.db_port
}

output "postgres_database_name" {
  description = "Name of the initial production PostgreSQL database."
  value       = module.database.db_name
}

output "postgres_master_username" {
  description = "Master username for the production PostgreSQL database."
  value       = module.database.master_username
}

output "postgres_master_user_secret_arn" {
  description = "ARN of the AWS-managed secret containing the production PostgreSQL master credentials."
  value       = module.database.master_user_secret_arn
}
