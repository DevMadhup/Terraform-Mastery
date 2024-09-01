# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "development-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Development-VPC"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "development-public-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1a"

  tags = {
    Name = "development-public-subnet-1"
  }
}

resource "aws_subnet" "development-public-2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1a"

  tags = {
    Name = "development-public-subnet-2"
  }
}

# Creating Private Subnets in VPC
resource "aws_subnet" "development-private-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "development-private-subnet-1"
  }
}

resource "aws_subnet" "development-private-2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "development-private-subnet-2"
  }
}


# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "development-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "development-gateway"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "development-public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "development-public-route-1"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "development-public-1-a" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "development-public-2-a" {
  subnet_id      = aws_subnet.dev-public-2.id
  route_table_id = aws_route_table.dev-public.id
}
