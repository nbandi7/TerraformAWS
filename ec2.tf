resource "aws_instance" "ec2Public" {
  count         = length(var.subnets_cidr_public)
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.publicSubnet[count.index].id

  key_name               = "testKP"
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = file("user_data.sh")

  tags = {
    Name = "Public-${count.index + 1}"
  }
}

resource "aws_instance" "ec2Private" {
  count         = length(var.subnets_cidr_private)
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.privateSubnet[count.index].id

  key_name               = "testKP"
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = file("user_data.sh")
  
  tags = {
    Name = "Private-${count.index + 1}"
  }
}