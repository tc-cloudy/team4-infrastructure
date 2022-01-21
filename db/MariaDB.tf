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

# make db subnet group 
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [data.aws_subnet.DBSubnetA.id, data.aws_subnet.DBSubnetB.id]

   tags = {
    Name = "db_subnet"
  }
}


data "aws_subnet" "DBSubnetA" {
    filter {
    name   = "tag:Name"
    values = ["DB_SubnetA"]
    }
}

data "aws_subnet" "DBSubnetB" {
    filter {
    name   = "tag:Name"
    values = ["DB_SubnetB"]
    }
}