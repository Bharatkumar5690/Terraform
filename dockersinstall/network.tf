resource "aws_vpc" "main_vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "main_vpc"
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }

  depends_on = [
    aws_vpc.main_vpc
  ]
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private_subnet"
  }

  depends_on = [
    aws_vpc.main_vpc
  ]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "gw"
  }

  depends_on = [
    aws_subnet.public_subnet
  ]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id


  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

