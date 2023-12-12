variable "cron_expression" {
  description = "The Cron expression for snapshot"
  type        = string
  default     = "0 0 ? * SUN *"
}

variable "dev" {
  description = "The device name to attach to the instance."
  type        = string
}

variable "retain_count" {
  description = "number of retention for the backup"
  type        = number
  default = 3
}

variable "instance_id" {
  description = "The ID of the instance to which the EBS volume will attach."
  type        = string
}

variable "name_suffix" {
  description = "The suffix for the policy name to be unique"
  type        = string
  default = ""
}

variable "availability_zone" {
  description = "The Availability Zone in which to create the volume."
  type        = string
}

variable "size" {
  description = "The size of the volume in GiBs."
  type        = number
}

variable "type" {
  description = "The type of the EBS volume (gp2, io1, st1, etc.)."
  type        = string
}
