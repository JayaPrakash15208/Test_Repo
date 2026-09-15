output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.web.public_dns
}

output "ami_id" {
  description = "ec2 created by this data block ami"
  value       = data.aws_ami.amazon_linux.id
}


