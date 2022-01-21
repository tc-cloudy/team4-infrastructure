data "aws_ami” “amazon-linux-2" {
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
# Create EC2 ( only after RDS is provisioned)
resource "aws_instance" "wordpressec2" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.PrivateSubnetA.id
  security_groups= [aws_security_group.ec2_allow_rule.id]
  user_data = "${data.template_file.user_data.rendered}"
  key_name = "wordpressec2"
  tags = {
    Name = "Wordpress.web"
  }
  # this will stop creating EC2 before RDS is provisioned
  depends_on = [aws_db_instance.wordpressdb]
}
# creating Elastic IP for EC2
resource "aws_eip" "eip" {
  instance = aws_instance.wordpressec2.id
}
output "IP" {
    value = aws_eip.eip.public_ip
}
output "RDS-Endpoint" {
    value = "${aws_db_instance.wordpressdb.endpoint}"
}
output "INFO" {
  value= "AWS Resources and Wordpress has been provisioned. Go to http://${aws_eip.eip.public_ip}"
}