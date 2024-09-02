resource "aws_vpc" "Production" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Production"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Production.id

  tags = {
    Name = "Production-internet-gw"
  }
}

resource "aws_eip" "instance-ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "private-nat" {
  subnet_id     = aws_subnet.public-subnet.id
  allocation_id = aws_eip.instance-ip.id
  tags = {
    Name = "Production NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Production.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private-nat.id
  }
  tags = {
    Name = "Private route"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Production.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public route"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.Production.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.Production.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "Private_subnet"
  }
}
