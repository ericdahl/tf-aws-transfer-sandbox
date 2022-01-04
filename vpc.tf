resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_10_1_0_0" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_10_2_0_0" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = {
    "public_10_1_0_0" : aws_subnet.public_10_1_0_0
    "public_10_2_0_0" : aws_subnet.public_10_2_0_0
  }
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}