provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "InternetGateway"
  }
}


resource "aws_subnet" "publicSub" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"

  tags = {
    Name = "PublicSubnet"
  }
}

# resource "aws_subnet" "privateSub" {
#   cidr_block = "10.0.2.0/24"
#   vpc_id     = aws_vpc.vpc.id

#   tags = {
#     Name = "PrivateSubnet"
#   }
# }

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# resource "aws_route_table" "privateRT" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "PrivateRouteTable"
#   }
# }

resource "aws_route_table_association" "publicRTAsc" {
  subnet_id      = aws_subnet.publicSub.id
  route_table_id = aws_route_table.publicRT.id
}

# resource "aws_route_table_association" "privateSubnetAsc" {
#   subnet_id      = aws_subnet.privateSub.id
#   route_table_id = aws_route_table.privateRT.id
# }

resource "aws_security_group" "sg" {
  name        = "sg_ssh_http"
  description = "Security group for Instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPD Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.publicSub.id

  key_name               = "testDemo"
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "EC2Master"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo dnf install httpd -y"
  #     #"sleep 120",
  #     # "sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
  #     # "sudo dnf -y install ansible",
  #     # "sudo dnf -y install git",
  #   ]
  # }
  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   host        = "${aws_instance.ec2.public_ip}"
  #   private_key = "${file()}"
  # }
}

output "aws_instance" {
  value = aws_instance.ec2.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}

output "aws_subnet" {
  value = aws_subnet.publicSub.id
}

output "aws_route_table" {
  value = aws_route_table.publicRT.id
}

output "aws_route_table_association" {
  value = aws_route_table_association.publicRTAsc.id
}

output "aws_security_group" {
  value = aws_security_group.sg.id
}