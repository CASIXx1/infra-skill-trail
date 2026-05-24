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

resource "aws_subnet" "cache_1a" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.20.30.0/24"

  tags = {
    Name = "${var.name}-cache-1a"
    Tier = "cache"
  }
}

resource "aws_subnet" "cache_1c" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.20.31.0/24"

  tags = {
    Name = "${var.name}-cache-1c"
    Tier = "cache"
  }
}
