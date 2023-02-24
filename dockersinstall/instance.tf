resource "aws_instance" "instance" {
  count = var.instance_count
  ami           = "ami-062df10d14676e201"
  associate_public_ip_address = var.public_ip
  instance_type = "t2.micro"
  key_name = "myimport"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = aws_subnet.public_subnet.id
  availability_zone = "ap-south-1a"

  tags = {
    "Name" = "instance1"
  }
}


resource "null_resource" "webprovisoner" {
  triggers = {
    running_number = var.trigger
  }

   connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = aws_instance.instance[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "sudo usermod -aG docker ubuntu"
    ]
  }
}


