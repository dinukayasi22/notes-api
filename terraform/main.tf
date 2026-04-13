# =============================================
# main.tf
# Provisions EC2 instance, security group,
# and key pair for the Notes API
# =============================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ─── Provider ────────────────────────────────
provider "aws" {
  region = var.aws_region
}

# ─── Key Pair ────────────────────────────────
resource "aws_key_pair" "notes_key" {
  key_name   = "${var.app_name}-key"
  public_key = file(var.public_key_path)
}

# ─── Security Group ──────────────────────────
resource "aws_security_group" "notes_sg" {
  name        = "${var.app_name}-sg"
  description = "Security group for Notes API"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # API port
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Notes API"
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  # Jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Jenkins"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}

# ─── EC2 Instance ─────────────────────────────
resource "aws_instance" "notes_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.notes_key.key_name
  vpc_security_group_ids = [aws_security_group.notes_sg.id]

  # Run setup.sh on first boot
  user_data = <<-EOF
    #!/bin/bash
    apt update && apt upgrade -y
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker ubuntu
    apt install -y docker-compose-plugin git
    systemctl enable docker
    systemctl start docker
  EOF

  tags = {
    Name        = var.app_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
