output "secret_arns" {
  description = "Secret ARNs keyed by the input map keys."
  value       = { for key, secret in aws_secretsmanager_secret.this : key => secret.arn }
}

output "secret_names" {
  description = "Secret names keyed by the input map keys."
  value       = { for key, secret in aws_secretsmanager_secret.this : key => secret.name }
}
