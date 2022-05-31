# Get AMI
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["my-vm-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Create EIP
resource "aws_eip" "packer" {
  instance = aws_instance.packer.id
  vpc      = true
  depends_on = [
    module.vpc.igw_id
  ]
}

# Attach EIP
resource "aws_eip_association" "packer" {
  instance_id   = aws_instance.packer.id
  allocation_id = aws_eip.packer.id
}

# Create EC2
resource "aws_instance" "packer" {
  ami                    = data.aws_ami.ami.id #var.packer_ami
  key_name               = var.key_name
  instance_type          = var.instance_type
  subnet_id              = element(module.vpc.public_subnets, 0)
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

# Create SG
resource "aws_security_group" "access_packer" {
  name   = "access_packer_vm"
  vpc_id = module.vpc.vpc_id

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
