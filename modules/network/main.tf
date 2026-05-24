resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.this.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.20.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-1a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.this.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-1c"
    Tier = "public"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.20.10.0/24"

  tags = {
    Name = "${var.name}-private-1a"
    Tier = "private"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.20.11.0/24"

  tags = {
    Name = "${var.name}-private-1c"
    Tier = "private"
  }
}

resource "aws_subnet" "database_1a" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.20.20.0/24"

  tags = {
    Name = "${var.name}-database-1a"
    Tier = "database"
  }
}

resource "aws_subnet" "database_1c" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.20.21.0/24"

  tags = {
    Name = "${var.name}-database-1c"
    Tier = "database"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}
