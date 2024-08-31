variable "ec2-instance-ami" {
  type    = string
  default = "ami-0d53d72369335a9d6"
}

variable "ec2-instance-type" {
  type    = string
  default = "t2.micro"
}

variable "aws-region" {
  type    = string
  default = "us-west-1"
}

variable "aws-ec2-instance-tag" {
  type    = string
  default = "Wanderlust-Master"
}

variable "ec2-instance-key" {
  type    = string
  default = "Wanderlust-key"
}

variable "ec2-security-tag" {
  type    = string
  default = "Wanderlust-Security"
}
