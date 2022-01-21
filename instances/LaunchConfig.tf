data "aws_vpc" "vpc" {
  tags = {
    Name = "Main_VPC"
  }
}
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
resource "aws_security_group" "ASGSecurityGroup" {
  name = "AutoScaling-Security-Group-webserverAB"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "ASG_securitygroup"
  }
}
data "aws_vpc" "vpc-for-asg" {
  tags = {
    Name = "Main_VPC"
  }
}
#ASG - EC2 -AMI
data "aws_ami" "amazon-linux-2-ec2" {
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
# ASG
resource "aws_launch_configuration" "ec2_asgconfig" {
  name          = "ec2asgconfig"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name = "EC2ASGConfig-keypair"
  security_groups = [aws_security_group.ec2_securitygroup.id]
}
