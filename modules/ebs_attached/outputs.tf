output "ebs_volume_id" {
  description = "The ID of the EBS volume"
  value       = aws_ebs_volume.volume.id
}

output "volume_attachment_id" {
  description = "The ID of the EBS volume attachment"
  value       = aws_volume_attachment.attach.id
}

output "dlm_lifecycle_policy_id" {
  description = "The ID of the DLM lifecycle policy"
  value       = aws_dlm_lifecycle_policy.snap.id
}
