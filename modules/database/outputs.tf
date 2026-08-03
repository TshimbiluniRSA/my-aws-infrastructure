output "db_instance_id" {
  description = "ID of the RDS database instance."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the RDS database instance."
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "Connection endpoint for the RDS database, including the port."
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "DNS address of the RDS database."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port on which the RDS database accepts connections."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the initial PostgreSQL database."
  value       = aws_db_instance.this.db_name
}

output "master_username" {
  description = "Master username for the PostgreSQL database."
  value       = aws_db_instance.this.username
}

output "master_user_secret_arn" {
  description = "ARN of the AWS-managed Secrets Manager secret containing the master user credentials."
  value       = try(one(aws_db_instance.this.master_user_secret).secret_arn, null)
}
