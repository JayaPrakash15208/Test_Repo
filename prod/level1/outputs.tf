output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.my-ec2.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.my-ec2.public_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.my-ec2.public_dns
}
