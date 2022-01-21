resource "aws_db_instance" "wordpressdb" {
  identifier = "wordpressdb"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_subnet_group_name  = aws_db_subnet_group.RDS_subnet_grp.name
  vpc_security_group_ids = [data.aws_security_group.databaseSG.id]
  name                 = "wpdb"
  username             = "team4"
  password             = "replatform4"
  skip_final_snapshot  = true
      tags = {
        Name = "DB"
  }
}
# change USERDATA varible value after grabbing RDS endpoint info
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"
  vars = {
    db_username= "team4"
    db_user_password= "replatform4"
    db_name= "wpdb"
    db_RDS= aws_db_instance.wordpressdb.endpoint
  }
}
# Create RDS Subnet group
resource "aws_db_subnet_group" "RDS_subnet_grp" {
   subnet_ids  = [data.aws_subnet.DBSubnetA.id, data.aws_subnet.DBSubnetB.id ]
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
data "aws_security_group" "databaseSG" {
    filter {
    name   = "tag:Name"
    values = ["RDS_securitygroup"]
  }
  }