resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "This is public security group"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "HTTP"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    /*ingress {
    description      = "custom"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }*/

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public_sg"
  }
}

resource "aws_network_interface" "mynetwork" {
  subnet_id       = aws_subnet.public_subnet.id
  tags = {
    "Name" = "mynetwork"
  }
}