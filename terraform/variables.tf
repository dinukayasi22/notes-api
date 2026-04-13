# =============================================
# variables.tf
# All configurable variables for the
# Notes API infrastructure
# =============================================

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-north-1"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "notes-api"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu 24.04 LTS AMI ID for eu-north-1"
  type        = string
  default     = "ami-089146c5626baa6bf"
}

variable "app_port" {
  description = "Port the Notes API runs on"
  type        = number
  default     = 5000
}

variable "public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default     = "~/.ssh/notes-api-key.pub"
}
