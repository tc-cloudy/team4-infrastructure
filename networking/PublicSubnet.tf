#NATGATEWAY AZ-A 
resource "aws_eip" "eipA" {
  vpc = true
  tags = {
    Name = "EipA"
  }
  depends_on = [aws_internet_gateway.IGW]
}
resource "aws_nat_gateway" "NAT-A" {
  subnet_id     = aws_subnet.PublicSubnetA.id 
  allocation_id = aws_eip.eipA.id 
  tags = {
    Name = "NAT_GATEWAYA"
  }
   depends_on = [aws_internet_gateway.IGW]
}



#NATGATEWAY AZ-B
resource "aws_eip" "eipB" {
  vpc = true
  
  tags = {
    Name = "EipB"
  }
  depends_on = [aws_internet_gateway.IGW]
}
resource "aws_nat_gateway" "NatB" {
  subnet_id     = aws_subnet.PublicSubnetB.id
  allocation_id = aws_eip.eipB.id
  
  tags = {
    Name = "NAT_GATEWAYB"
  }

  depends_on = [aws_internet_gateway.IGW]
}




#BastionHost A
resource "aws_instance" "bastionA" {
  ami                         = "ami-01efa4023f0f3a042"
  instance_type               = "t2.micro"
  subnet_id = aws_subnet.PublicSubnetA.id
  vpc_security_group_ids  = [aws_security_group.bastion.id]
  key_name = "bastion-key"
  associate_public_ip_address = true
  tags = {
    Name = "BastionHostA"
  }
  depends_on = [aws_internet_gateway.IGW]
}

#BastionHost B
resource "aws_instance" "bastionhostb" {
  ami                         = "ami-01efa4023f0f3a042"
  instance_type               = "t2.micro"
  subnet_id = aws_subnet.PublicSubnetB.id
  vpc_security_group_ids  = [aws_security_group.bastion.id]
  key_name = "bastion-key"
  associate_public_ip_address = true
  tags = {
    Name = "BastionHostB"
  }
  depends_on = [aws_internet_gateway.IGW]
}



