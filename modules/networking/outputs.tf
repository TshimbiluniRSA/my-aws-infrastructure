output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "IPv4 address range of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets ordered consistently with availability_zones"
  value       = [for availability_zone in var.availability_zones : aws_subnet.public[availability_zone].id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets ordered consistently with availability_zones"
  value       = [for availability_zone in var.availability_zones : aws_subnet.private[availability_zone].id]
}

output "public_subnet_cidrs" {
  description = "IPv4 CIDR blocks of the public subnets ordered consistently with availability_zones"
  value       = [for availability_zone in var.availability_zones : aws_subnet.public[availability_zone].cidr_block]
}

output "private_subnet_cidrs" {
  description = "IPv4 CIDR blocks of the private subnets ordered consistently with availability_zones"
  value       = [for availability_zone in var.availability_zones : aws_subnet.private[availability_zone].cidr_block]
}
