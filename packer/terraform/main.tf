terraform {
  required_version = ">= v1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.10.0"
    }
  }
  backend "s3" {
    bucket  = "packertfstate"
    key     = "ec2.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

output "PACKER_EIP" {
  value = aws_instance.packer.public_ip
}
