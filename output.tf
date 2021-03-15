output "myVPCId" {
  value = aws_vpc.myVpc.id
}

output "publicSubnetIds" {
  value = aws_subnet.publicSubnet.*.id
}

output "privateSubnetIds" {
  value = aws_subnet.privateSubnet.*.id
}

output "internetGatewayId" {
  value = aws_internet_gateway.myVpcInternetGateway.id
}

output "natGatewayId" {
  value = aws_nat_gateway.myVpcNatGateway.id
}

output "publicRouteTableId" {
  value = aws_vpc.myVpc.default_route_table_id
}

output "privateRouteTableId" {
  value = aws_route_table.privateRouteTable.id
}

output "elasticIP" {
  value = aws_eip.eip.public_ip
}

output "publicInstances" {
  value = aws_instance.ec2Public.*.id
}