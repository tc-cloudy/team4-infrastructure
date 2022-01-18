data "aws_vpc" "vpc" {
  tags = {
    Name = "Main_VPC"
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

data "aws_nat_gateway" "natgwa" {
   filter {
    name   = "tag:Name"
    values = ["NAT_GATEWAYA"]
  }
}

data "aws_nat_gateway" "natgwb" {
   filter {
    name   = "tag:Name"
    values = ["NAT_GATEWAYB"]
  }
}

# WP subnet routes for NAT-A
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

# WP subnet routes for NAT-A
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

#AMI
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

//security group for EC2
resource "aws_security_group" "ec2_securitygroup" { 
  name = "ec2_securitygroup"
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

   ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "ec2_securitygroup"
  }
}

# WP SERVERS 
resource "aws_instance" "wp-serverA" {
  ami = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids  = [aws_security_group.ec2_securitygroup.id]
  instance_type= "t2.micro"
  subnet_id = aws_subnet.PrivateSubnetA.id
  key_name = "ec2instance-key"
  user_data = file("files/userdata.sh")
  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "wp-serverB" {
  ami = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids  = [aws_security_group.ec2_securitygroup.id]
  instance_type= "t2.micro"
  subnet_id = aws_subnet.PrivateSubnetB.id
  key_name = "ec2instance-key"
  user_data = file("files/userdata.sh")
  tags = {
    Name = "webserver"

  }

 


}



#####
