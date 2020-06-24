resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "publicSub" {
  count                   = length(var.subnets_cidr_public)
  cidr_block              = element(var.subnets_cidr_public, count.index)
  availability_zone       = element(var.azs_public, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"

  tags = {
    Name             = "PublicSubnet"
    AvailabilityZone = "Subnet-${count.index + 1}"
  }
}


resource "aws_subnet" "privateSub" {
  count                   = length(var.subnets_cidr_private)
  cidr_block              = element(var.subnets_cidr_private, count.index)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.azs_private, count.index)
  map_public_ip_on_launch = "false"

  tags = {
    Name             = "PrivateSubnet"
    AvailabilityZone = "Subnets-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "InternetGateway"
  }
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
#   count         = length(var.subnets_cidr_public)
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicSub[0].id
}

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

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "publicRTAsc" {
  count          = length(var.subnets_cidr_public)
  subnet_id      = aws_subnet.publicSub[count.index].id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "privateSubnetAsc" {
  count          = length(var.subnets_cidr_private)
  subnet_id      = aws_subnet.privateSub[count.index].id
  route_table_id = aws_route_table.privateRT.id
}