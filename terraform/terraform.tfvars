# =============================================
# terraform.tfvars.example
# Copy to terraform.tfvars and fill in values
# NEVER commit terraform.tfvars to GitHub!
# =============================================

aws_region      = "eu-north-1"
app_name        = "notes-api"
environment     = "production"
instance_type   = "t3.micro"
app_port        = 5000
public_key_path = "~/.ssh/notes-api-key.pub"
