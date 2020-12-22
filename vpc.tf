resource "aws_vpc" "sanju" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
 
  tags = {
    Name = "sanju"
  }
}
resource "aws_subnet" "pvt" {
  vpc_id     = aws_vpc.sanju.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "private"
  }
}
resource "aws_subnet" "pub" {
  vpc_id     = aws_vpc.sanju.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sanju.id

  tags = {
    Name = "IGW"
  }
}
resource "aws_eip" "ip" {
  vpc      = true
   tags = {
    Name = "sanju elastic"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.pvt.id
  
  tags = {
    Name = "NGW"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.sanju.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

    tags = {
    Name = "custom"
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.sanju.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

    tags = {
    Name = "custom"
  }
}

resource "aws_route_table_association" "s1" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt1.id
}
resource "aws_route_table_association" "s2" {
  subnet_id      = aws_subnet.pvt.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_security_group" "sg" {
  name        = "sanju_allow_all"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sanju.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.sanju.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sanju_allow_all"
  }
}