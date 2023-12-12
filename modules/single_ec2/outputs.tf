output "private_key_pem" {
  description = "The private key data in PEM format."
  value       = tls_private_key.ecs_key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "The public key data in OpenSSH authorized_keys format, if available."
  value       = tls_private_key.ecs_key.public_key_openssh
}

output "key_pair_name" {
  description = "The key pair name."
  value       = aws_key_pair.deployer.key_name
}

output "ami_id" {
  description = "The AMI ID used for the instance."
  value       = aws_instance.ec2_instance.ami
}

output "instance_id" {
  description = "The instance ID"
  value       = aws_instance.ec2_instance.id
}

output "availability_zone" {
  description = "The availability zone"
  value = aws_instance.ec2_instance.availability_zone
}

output "instance_public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = aws_instance.ec2_instance.public_ip
}

output "instance_private_ip" {
  description = "The private IP address assigned to the instance."
  value       = aws_instance.ec2_instance.private_ip
}