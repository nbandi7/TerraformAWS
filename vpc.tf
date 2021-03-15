resource "aws_vpc" "myVpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "publicSubnet" {
  vpc_id                  = aws_vpc.myVpc.id
  count                   = length(var.subnets_cidr_public)
  availability_zone       = element(var.azs_public, count.index)
  cidr_block              = element(var.subnets_cidr_public, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "privateSubnet" {
  vpc_id                  = aws_vpc.myVpc.id
  count                   = length(var.subnets_cidr_private)
  availability_zone       = element(var.azs_private, count.index)
  cidr_block              = element(var.subnets_cidr_private, count.index)
  map_public_ip_on_launch = "false"
  tags = {
    "Name" = "PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "myVpcInternetGateway" {
  vpc_id = aws_vpc.myVpc.id
  tags = {
    "Name" = "myVPCGateway"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "myVPCElasticIP"
  }
}

resource "aws_nat_gateway" "myVpcNatGateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicSubnet[0].id
  tags = {
    "Name" = "myNATGateway"
  }
}

resource "aws_default_route_table" "publicRouteTable" {
  default_route_table_id = aws_vpc.myVpc.default_route_table_id
  #   vpc_id = aws_vpc.myVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myVpcInternetGateway.id
  }
  tags = {
    "Name" = "PublicRouteTable"
  }
}

resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.myVpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myVpcNatGateway.id
  }
  tags = {
    "Name" = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "publicRouteTableAssociation" {
  count          = length(var.subnets_cidr_public)
  subnet_id      = element(aws_subnet.publicSubnet.*.id, count.index)
  route_table_id = aws_vpc.myVpc.default_route_table_id
}

resource "aws_route_table_association" "privateRouteTableAssociation" {
  count          = length(var.subnets_cidr_private)
  subnet_id      = element(aws_subnet.privateSubnet.*.id, count.index)
  route_table_id = aws_route_table.privateRouteTable.id
}