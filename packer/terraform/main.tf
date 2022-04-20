terraform {
  required_version = ">= v1.1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.10.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "packer_ami" {
  type    = string
  default = ""
}

variable "key_name" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

# Provision EC2
resource "aws_eip" "packer" {
  instance = aws_instance.packer.id
  vpc      = true
}

resource "aws_eip_association" "packer" {
  instance_id   = aws_instance.packer.id
  allocation_id = aws_eip.packer.id
}

resource "aws_instance" "packer" {
  ami                    = var.packer_ami
  key_name               = var.key_name
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = ["${aws_security_group.access_packer.id}"]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
    tags = {
      Name = "packer-ec2"
    }
  }

  tags = {
    Name = "packer-ec2"
  }
}

resource "aws_security_group" "access_packer" {
  name   = "access_packer"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "access_packer_vm"
  }
}

output "PACKER_EIP" {
  value = aws_instance.packer.public_ip
}