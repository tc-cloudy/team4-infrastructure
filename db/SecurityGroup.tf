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



# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = data.aws_vpc.vpc.id
  name = "RDS_SG"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.ec2SG.id]
  }
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
