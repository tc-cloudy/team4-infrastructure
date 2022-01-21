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

# WP SERVERS AZ-A
resource "aws_instance" "wp-serverA" {
  ami = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids  = [aws_security_group.ec2_securitygroup.id]
  instance_type= "t2.micro"
  subnet_id = data.aws_subnet.PrivateSubnetA.id
  key_name = "ec2instance-key"
  user_data = file("files/userdata.tfpl")
  tags = {
    Name = "webserver A"
         }
  depends_on = [data.aws_db_instance.rds]
}


# WP SERVERS AZ-B
resource "aws_instance" "wp-serverB" {
  ami = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids  = [aws_security_group.ec2_securitygroup.id]
  instance_type= "t2.micro"
  subnet_id = data.aws_subnet.PrivateSubnetB.id
  key_name = "ec2instance-key"
  user_data = file("files/userdata.tfpl")
  tags = {
    Name = "webserver B"
          }
depends_on = [data.aws_db_instance.rds]
}



data "aws_subnet" "PrivateSubnetA" {
    filter {
    name   = "tag:Name"
    values = ["Private_SubnetA"]
    }
}

data "aws_subnet" "PrivateSubnetB" {
    filter {
    name   = "tag:Name"
    values = ["Private_SubnetB"]
    }
}

data "aws_db_instance" "rds" {
  db_instance_identifier = "wp-db"
}







