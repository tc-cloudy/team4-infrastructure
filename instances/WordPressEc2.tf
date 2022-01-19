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
  subnet_id = aws_subnet.PrivateSubnetA.id
  key_name = "ec2instance-key"
  user_data = file("files/userdata.sh")
  tags = {
    Name = "webserver A"
         }
}


# WP SERVERS AZ-B
resource "aws_instance" "wp-serverB" {
  ami = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids  = [aws_security_group.ec2_securitygroup.id]
  instance_type= "t2.micro"
  subnet_id = aws_subnet.PrivateSubnetB.id
  key_name = "ec2instance-key"
  user_data = file("files/userdata.sh")
  tags = {
    Name = "webserver B"
          }
}