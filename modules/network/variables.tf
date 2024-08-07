variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "The name tag for the VPC"
  type        = string
  default     = "nexomis_IaC_vpc"
}

variable "s3_gateway_region" {
  description = "The region for the S3 endpoint Gateway"
  type        = string
  default     = "eu-west-3"
}

variable "public_subnets" {
  description = "A list of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnet CIDRs"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group configurations"
  type = list(object({
    name        = string
    description = string
    open_ports  = list(number)
  }))
}