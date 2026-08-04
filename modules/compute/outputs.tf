output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.this.arn
}

output "instance_private_ip" {
  description = "Private IPv4 address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "instance_availability_zone" {
  description = "Availability Zone of the EC2 instance."
  value       = aws_instance.this.availability_zone
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile attached to the EC2 instance."
  value       = aws_iam_instance_profile.ec2.name
}

output "iam_role_name" {
  description = "Name of the EC2 IAM role."
  value       = aws_iam_role.ec2.name
}

output "iam_role_arn" {
  description = "ARN of the EC2 IAM role."
  value       = aws_iam_role.ec2.arn
}

output "elastic_ip" {
  description = "Stable public Elastic IP address associated with the EC2 instance."
  value       = aws_eip.this.public_ip
}

output "elastic_ip_allocation_id" {
  description = "Allocation ID of the Elastic IP."
  value       = aws_eip.this.id
}

output "ami_id" {
  description = "AMI ID used by the EC2 instance."
  value       = nonsensitive(data.aws_ssm_parameter.amazon_linux_2023_ami.value)
}
