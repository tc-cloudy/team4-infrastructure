# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = var.vpc_name
  }
}

# Create IGW for internet connection 
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_internet_gateway
  }
}


#PublicSubnet for NATGW- azA & azB
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

#PrivateSubnet for the ec2- azA & azB
resource "aws_subnet" "PrivateSubnetA" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PrivateSubnetA_cidr
  availability_zone = var.PrivateSubnetA_az
  map_public_ip_on_launch = "false" //it makes private subnet

  tags = {
    Name = "Private_SubnetA"
  }
}
resource "aws_subnet" "PrivateSubnetB" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PrivateSubnetB_cidr
  availability_zone = var.PrivateSubnetB_az
  map_public_ip_on_launch = "false" //it makes private subnet

  tags = {
    Name = "Private_SubnetB"
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

# Create RDS Subnet group
resource "aws_db_subnet_group" "RDS_subnet_grp" {
   subnet_ids  = ["${aws_subnet.DBSubnetA.id}","${aws_subnet.DBSubnetB.id}"]
}



# Creating Public Route table 
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "PublicRT"
  }
}

# Associating route tabe to public subnet
resource "aws_route_table_association" "PublicAssociation" {
  subnet_id      = aws_subnet.PublicSubnetA.id
  route_table_id = aws_route_table.PublicRT.id
}

# Creating Private Route table 
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-A.id
  }

  tags = {
    Name = "PrivateRT"
  }
}

# Associating route tabe to public subnet
resource "aws_route_table_association" "PrivateAssociation" {
  subnet_id      = aws_subnet.PrivateSubnetA.id
  route_table_id = aws_route_table.PrivateRT.id
}