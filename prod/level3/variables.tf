variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {

  description = "instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {

  description = "instance name"
  type        = string
  default     = "terraform-ec2"
}

variable "ami" {

  description = "instance ami"
  type        = string
  default     = "ami-0a157bd98d97a9589"
}
variable "key_name" {
  description = "keypair name"
  type        = string
  default     = "my-ec2-keypair"
}



