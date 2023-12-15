variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t4g.nano"
}

variable "name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the EC2 instance"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = false
}

variable "security_group_id" {
  description = "The ID of the security group for the EC2 instance"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Instance Profile to launch the instance with"
  type        = string
  default     = ""
}

output "is_arm_instance" {
  value = local.is_arm_instance
}

variable "volume_size" {
  description = "Volume size for the EC2 instance (Default: 8GB)"
  type        = number
  default     = null 
}

variable "spot_instance" {
  description = "Whether the instance use spot pricing"
  type        = bool
  default     = false 
}

variable "spot_instance_type" {
  description = "spot_instance_type either one-time or persistent"
  type        = string
  default     = "persistent"
}
