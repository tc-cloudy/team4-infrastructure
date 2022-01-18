#PublicSubnet for NATGW, BastionHost - azA & azB
resource "aws_subnet" "PublicSubnetA" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PublicSubnetA_cidr
  availability_zone = var.PublicSubnetA_az
  map_public_ip_on_launch = "true" //it makes this a public subnet

  tags = {
    Name = "Public_SubnetA"
  }
}
resource "aws_subnet" "PublicSubnetB" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PublicSubnetB_cidr
  availability_zone = var.PublicSubnetB_az
  map_public_ip_on_launch = "true" //it makes this a public subnet

  tags = {
    Name = "Public_SubnetB"
  }
}

#Routing Table
resource "aws_route_table" "public-routes" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }

    tags = {
    Name = "public-routes"
  }
}
resource "aws_route_table_association" "public-subnet-routes-1" {
    subnet_id = aws_subnet.PublicSubnetA.id
    route_table_id = aws_route_table.public-routes.id
}

resource "aws_route_table_association" "public-subnet-routes-2" {
    subnet_id = aws_subnet.PublicSubnetB.id
    route_table_id = aws_route_table.public-routes.id
}



#NatGW 
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




#BastionHost
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


# Security group for bastion host.
resource "aws_security_group" "bastion" { 
  name = "bastion_SG"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Bastion_securitygroup"
  }
}

#v1.0





