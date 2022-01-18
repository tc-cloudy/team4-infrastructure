data "aws_vpc" "vpc" {
  tags = {
    Name = "Main_VPC"
  }
}

data "aws_security_group" "ec2SG" {
    filter {
    name   = "tag:Name"
    values = ["ec2_securitygroup"]
    }
}

#DBSubnet for the RDS- azA & azB
resource "aws_subnet" "DBSubnetA" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.DBSubnetA_cidr
  availability_zone = var.DBSubnetA_az
  map_public_ip_on_launch = "false" //it makes private subnet

  tags = {
    Name = "DB_SubnetA"
  }
}
resource "aws_subnet" "DBSubnetB" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.DBSubnetB_cidr
  availability_zone = var.DBSubnetB_az
  map_public_ip_on_launch = "false" //it makes private subnet

  tags = {
    Name = "DB_SubnetB"
  }
}

# make db subnet group 
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = ["${aws_subnet.DBSubnetA.id}", "${aws_subnet.DBSubnetB.id}"]
}









