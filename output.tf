output "instance_public_id" {
  description = "Public ip address of the EC2 instance"
  value       = aws_instance.web_server[0].public_ip
}
output "insance_id" {
  value = aws_instance.web_server[0].id
  description = "ID of the EC2 instance"
  
}