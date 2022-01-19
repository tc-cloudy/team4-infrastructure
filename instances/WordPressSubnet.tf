#NATGW AZ-A
data "aws_nat_gateway" "natgwa" {
   filter {
    name   = "tag:Name"
    values = ["NAT_GATEWAYA"]
  }
}

#NATGW AZ-B
data "aws_nat_gateway" "natgwb" {
   filter {
    name   = "tag:Name"
    values = ["NAT_GATEWAYB"]
  }
}


#PrivateSubnet for the ec2- azA & azB
resource "aws_subnet" "PrivateSubnetA" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.PrivateSubnetA_cidr
  availability_zone = var.PrivateSubnetA_az
  tags = {
    Name = "Private_SubnetA"
  }
}
resource "aws_subnet" "PrivateSubnetB" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.PrivateSubnetB_cidr
  availability_zone = var.PrivateSubnetB_az
  tags = {
    Name = "Private_SubnetB"
  }
}

# WordPress subnet routes for NAT-A
resource "aws_route_table" "wp-subnet-routes-a" {
    vpc_id = data.aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = data.aws_nat_gateway.natgwa.id
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
    vpc_id = data.aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = data.aws_nat_gateway.natgwb.id
          }
    tags= {
        Name = "web-subnet-routes-B"
           }
}

resource "aws_route_table_association" "wp-subnet-routes-b" {
    subnet_id = aws_subnet.PrivateSubnetB.id
    route_table_id = aws_route_table.wp-subnet-routes-b.id
}