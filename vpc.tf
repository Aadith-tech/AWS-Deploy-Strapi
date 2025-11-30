
resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc.cidr_block
  enable_dns_hostnames = var.aws_vpc.enable_dns_hostnames
  enable_dns_support   = var.aws_vpc.enable_dns_support

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public_1" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet.cidr_block
  availability_zone       = var.public_subnet.availability_zone

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet1.cidr_block
  availability_zone       = var.private_subnet1.availability_zone

    tags = {
        Name = "private-subnet-2"
    }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet2.cidr_block
  availability_zone       = var.private_subnet2.availability_zone

  tags = {
    Name = "private-subnet-2"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-igw"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
    tags = {
        Name = "public-rt"
    }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}


