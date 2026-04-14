# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "timesheet-vpc" }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# PUBLIC SUBNET
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true
}

# PRIVATE SUBNET 1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.az_1
}

# PRIVATE SUBNET 2 (IMPORTANT FOR RDS)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az_2
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# ASSOCIATE PRIVATE SUBNETS
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}