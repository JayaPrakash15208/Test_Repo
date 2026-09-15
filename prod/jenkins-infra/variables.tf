variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for both servers"
  type        = string
  default     = "t3.micro"
}

variable "my_ip_cidr" {
  description = "Your IP address in CIDR form, used to restrict SSH/Jenkins UI access. Find yours at whatismyip.com and format as x.x.x.x/32"
  type        = string
}
