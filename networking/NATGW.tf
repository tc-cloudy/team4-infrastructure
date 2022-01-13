#NatGW for both AZs
resource "aws_eip" "eipA" {

  vpc = true

  tags = {
    Name = "EipA"
  }
}

resource "aws_nat_gateway" "NAT-A" {
  subnet_id     = aws_subnet.PublicSubnetA.id
  allocation_id = aws_eip.eipA.id

  tags = {
    Name = "NAT_GATEWAYA"
  }
}

resource "aws_eip" "eipB" {

  vpc = true

  tags = {
    Name = "EipB"
  }
}

resource "aws_nat_gateway" "NatB" {
  subnet_id     = aws_subnet.PublicSubnetB.id
  allocation_id = aws_eip.eipB.id

  tags = {
    Name = "NAT_GATEWAYB"
  }
}