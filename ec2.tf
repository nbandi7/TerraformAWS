resource "aws_instance" "ec2Public" {
  count         = length(var.subnets_cidr_public)
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.publicSub[count.index].id

  key_name               = "nagios"
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = file("user_data.sh")

  tags = {
    Name = "MasterPublic-${count.index + 1}"
  }

  #   provisioner "remote-exec" {
  #     inline = [
  #       "sudo yum install httpd -y",
  #       "sudo systemctl start httpd"
  #       # "sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
  #       # "sudo dnf -y install ansible",
  #       # "sudo dnf -y install git",
  #     ]
  #   }
  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     host        = aws_instance.ec2Public.public_ip
  #     private_key = file("E:\\nithin\\nagios stuff\\nagios.pem")
  #   }
}

resource "aws_instance" "ec2Private" {
  count         = length(var.subnets_cidr_private)
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.privateSub[count.index].id

  key_name               = "nagios"
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = file("user_data.sh")


  tags = {
    Name = "MasterPrivate-${count.index + 1}"
  }
}