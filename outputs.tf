# Output the Instance ID
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.kali-ec2.id
}

# Output the Kali Public IP
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.kali-ec2.public_ip
}