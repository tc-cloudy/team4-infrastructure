# AWS ASG resource
resource "aws_autoscaling_group" "ASG" {
  name                      = "asgwebserverab"
  max_size                  = 4
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 0
  force_delete              = true
  launch_configuration      = "aws_launch_configuration.ec2asgconfig.id"
  vpc_zone_identifier       = [
      "aws_subnet.private.eu-west-1a", 
      "aws_subnet.private.eu-west-1b"]
}
# AWS Launch config details
resource "aws_launch_configuration" "ASG" {
  name          = "web_config"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name = "EC2ASGConfig-keypair"
  security_groups = [aws_security_group.ec2_securitygroup.id]
}
