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
    Name = "vpc_internet_gateway"
  }
}

#Public Routing Table
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

#DBSubnet for the RDS- azA & azB
resource "aws_subnet" "DBSubnetA" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.DBSubnetA_cidr
  availability_zone = var.DBSubnetA_az
  map_public_ip_on_launch = "false" //it makes private subnet

  tags = {
    Name = "DB_SubnetA"
  }
}
resource "aws_subnet" "DBSubnetB" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.DBSubnetB_cidr
  availability_zone = var.DBSubnetB_az
  map_public_ip_on_launch = "false" //it makes private subnet

  tags = {
    Name = "DB_SubnetB"
  }
}


#PrivateSubnet for the ec2- azA & azB
resource "aws_subnet" "PrivateSubnetA" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PrivateSubnetA_cidr
  availability_zone = var.PrivateSubnetA_az
  tags = {
    Name = "Private_SubnetA"
  }
}
resource "aws_subnet" "PrivateSubnetB" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PrivateSubnetB_cidr
  availability_zone = var.PrivateSubnetB_az
  tags = {
    Name = "Private_SubnetB"
  }
}

# WordPress subnet routes for NAT-A
resource "aws_route_table" "wp-subnet-routes-a" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NAT-A.id
    }

    tags= {
        Name = "web-subnet-routes-A"
          }
}
resource "aws_route_table_association" "wp-subnet-routes-a" {
    subnet_id = aws_subnet.PrivateSubnetA.id
    route_table_id = aws_route_table.wp-subnet-routes-a.id
}


# WordPress subnet routes for NAT-B
resource "aws_route_table" "wp-subnet-routes-b" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NAT-B.id
          }
    tags= {
        Name = "web-subnet-routes-B"
           }
}

resource "aws_route_table_association" "wp-subnet-routes-b" {
    subnet_id = aws_subnet.PrivateSubnetB.id
    route_table_id = aws_route_table.wp-subnet-routes-b.id
}