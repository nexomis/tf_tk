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
  is_arm_instance = strcontains(var.instance_type, "g")
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
  iam_instance_profile        = var.iam_instance_profile_name
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
}