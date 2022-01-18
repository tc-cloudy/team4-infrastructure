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

# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = data.aws_vpc.vpc.id
  name = "RDS_SG"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.ec2SG.id]
    cidr_blocks = [
          var.DBSubnetA_cidr, # WP subnet
      
   ]

  }
  
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "RDS_securitygroup"
  }

}


# make db subnet group 
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = ["${aws_subnet.DBSubnetA.id}", "${aws_subnet.DBSubnetB.id}"]
}

resource "aws_db_instance" "wp-db" {
  identifier = "wp-db"
  instance_class = "db.t3.medium"
  allocated_storage = 20
  engine = "mariadb"
  engine_version = "10.5"
  name = "wordpress_db"
  password = var.aws_wp_db_password
  username = var.aws_wp_db_user
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.RDS_allow_rule.id]
}









