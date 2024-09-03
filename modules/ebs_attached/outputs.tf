output "ebs_volume_id" {
  description = "The ID of the EBS volume"
  value       = aws_ebs_volume.volume.id
}

output "volume_attachment_id" {
  description = "The ID of the EBS volume attachment"
  value       = aws_volume_attachment.attach.id
}
