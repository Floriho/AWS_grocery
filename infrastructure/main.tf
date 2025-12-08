terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Security Group für EC2
resource "aws_security_group" "ec2_sg" {
  name        = "simple-ec2-sg"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Default VPC laden
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# EC2 Instance
resource "aws_instance" "simple_ec2" {
  ami           = "ami-09042b2f6d07d164a" # Amazon Linux 2 in eu-central-1
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default_subnets.ids[0]
  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "MinimalTerraformEC2"
  }
}

output "instance_public_ip" {
  value = aws_instance.simple_ec2.public_ip
}
