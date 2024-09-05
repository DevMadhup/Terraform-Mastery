variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-1"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default = "Production VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "VCP cidr_block"
  default     = "10.0.0.0/16"
}

variable "internet_gateway_name" {
  type        = string
  description = "IGW name"
  default     = "Production-Internet-Gateway"
}

variable "nat_gateway_name" {
  type        = string
  description = "NAT Gateway name"
  default     = "Production-NAT-Gateway"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet cidr_block"
  default     = "10.0.1.0/24"
}

variable "public_subnet_availability_zone" {
  type        = string
  description = "Public subnet cidr_block"
  default     = "us-west-1a"
}

variable "allocate_public_ip_for_public_subnet" {
  type        = string
  description = "Allocate public IP for public subnet"
  default     = "true"
}

variable "public_subnet_name" {
  type        = string
  description = "Name of public subnet"
  default     = "Public-subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private subnet cidr_block"
  default     = "10.0.2.0/24"
}

variable "private_subnet_availability_zone" {
  type        = string
  description = "Private subnet cidr_block"
  default     = "us-west-1c"
}

variable "allocate_public_ip_for_private_subnet" {
  type        = string
  description = "Allocate public IP of private subnet"
  default     = "false"
}

variable "private_subnet_name" {
  type        = string
  description = "Name of private subnet"
  default     = "Private-subnet"
}

variable "private_route_table_cidr" {
  type        = string
  description = "cidr_block of private subnet"
  default     = "0.0.0.0/0"
}

variable "private_route_table_name" {
  type        = string
  description = "Name of private route table"
  default     = "Private route table"
}

variable "public_route_table_cidr" {
  type        = string
  description = "cidr_block of public subnet"
  default     = "0.0.0.0/0"
}

variable "public_route_table_name" {
  type        = string
  description = "Name of public route table"
  default     = "Public route table"
}
