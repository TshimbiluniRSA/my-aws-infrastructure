output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "IPv4 address range of the VPC"
  value       = aws_vpc.this.cidr_block
}
