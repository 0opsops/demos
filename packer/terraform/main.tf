terraform {
  required_version = ">= v1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.10.0"
    }
  }
  backend "s3" {
    bucket  = ""
    key     = ""
    region  = ""
    encrypt = ""
  }
}

provider "aws" {
  region = var.aws_region
}

output "PACKER_EIP" {
  value = aws_eip.packer.public_ip
}
