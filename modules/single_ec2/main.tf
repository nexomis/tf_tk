/**
 * This Terraform configuration file defines the resources required to provision an EC2 instance.
 * It generates a TLS private key, an AWS key pair, and a random pet name for the key suffix.
 * The EC2 instance is created using the specified AMI, instance type, subnet, security group, and other parameters.
 * The user data script sets the hostname of the instance.
 */

# Generate outputs for the following module
resource "tls_private_key" "ecs_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.name}-${random_pet.key_suffix.id}"
  public_key = tls_private_key.ecs_key.public_key_openssh
}

resource "random_pet" "key_suffix" {
  length    = 2
  separator = "-"
}

locals {
  is_arm_instance = strcontains(split(".", var.instance_type)[0], "g")
}

data "aws_ssm_parameter" "debian_bullseye_amd64_ami" {
  name = "/aws/service/debian/release/bullseye/latest/amd64"
}

data "aws_ssm_parameter" "debian_bullseye_arm64_ami" {
  name = "/aws/service/debian/release/bullseye/latest/arm64"
}

resource "aws_instance" "ec2_instance" {
  ami                         = local.is_arm_instance ? data.aws_ssm_parameter.debian_bullseye_arm64_ami.value : data.aws_ssm_parameter.debian_bullseye_amd64_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : null
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip

  dynamic "root_block_device" {
    for_each = var.volume_size != null ? [1] : []
    content {
      volume_size = var.volume_size
    }
  }

  key_name                    = aws_key_pair.deployer.key_name
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname ${var.name}
  EOF

  tags = {
    Name = "${var.name}"
  }

  dynamic "instance_market_options" {
    for_each = var.spot_instance ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        spot_instance_type = "$var.spot_instance_type"
      }
    }
  }
}
