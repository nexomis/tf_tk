output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.pub_subnet : subnet.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in aws_subnet.priv_subnet : subnet.id] # This will be created in main.tf
}

output "security_group_ids" {
  description = "The IDs of the security groups"
  value       = { for sg in aws_security_group.security_group : sg.name => sg.id }
}
