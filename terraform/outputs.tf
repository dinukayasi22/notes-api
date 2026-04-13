# =============================================
# outputs.tf
# Values printed after terraform apply
# =============================================

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.notes_server.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.notes_server.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/notes-api-key ubuntu@${aws_instance.notes_server.public_ip}"
}

output "api_url" {
  description = "URL to access the Notes API"
  value       = "http://${aws_instance.notes_server.public_ip}:5000/api/notes"
}

output "health_check_url" {
  description = "URL to check API health"
  value       = "http://${aws_instance.notes_server.public_ip}:5000/api/health"
}
