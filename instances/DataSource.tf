#VPC
data "aws_vpc" "vpc" {
  tags = {
    Name = "Main_VPC"
  }
}

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

#Wordpress - EC2 -AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["amazon"]
}