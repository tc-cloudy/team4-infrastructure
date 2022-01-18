#MAIN VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Main_VPC"
  }
}

# Internet Gatway:
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_internet_gateway
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