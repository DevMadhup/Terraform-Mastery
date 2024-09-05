# VPC resource
resource "aws_vpc" "Production" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Production.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# Elastic ip
resource "aws_eip" "instance-ip" {
  domain = "vpc"
}

# Private NAT Gateway
resource "aws_nat_gateway" "private-nat" {
  subnet_id     = aws_subnet.public-subnet.id
  allocation_id = aws_eip.instance-ip.id
  tags = {
    Name = var.nat_gateway_name
  }

  depends_on = [aws_internet_gateway.gw]
}

# Public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.Production.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_subnet_availability_zone
  map_public_ip_on_launch = var.allocate_public_ip_for_public_subnet
  tags = {
    Name = var.public_subnet_name
  }
}

# Private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.Production.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.private_subnet_availability_zone
  map_public_ip_on_launch = var.allocate_public_ip_for_private_subnet
  tags = {
    Name = var.private_subnet_name
  }
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Production.id

  route {
    cidr_block = var.private_route_table_cidr
    gateway_id = aws_nat_gateway.private-nat.id
  }
  tags = {
    Name = var.private_route_table_name
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Production.id

  route {
    cidr_block = var.public_route_table_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# Private route table association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private.id
}

# Public route table association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}
