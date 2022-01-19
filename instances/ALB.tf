data "aws_subnet" "PublicSubnetA" {
  tags = {
    Name = "Public_SubnetA"
  }
}

data "aws_subnet" "PublicSubnetB" {
  tags = {
    Name = "Public_SubnetB"
  }
}

data "aws_internet_gateway" "IGW"{
  tags = {
    Name = "vpc_internet_gateway"
  }
}
 

resource "aws_alb" "alb" {
  name = "ALB"
  subnets = [data.aws_subnet.PublicSubnetA.id, data.aws_subnet.PublicSubnetB.id,]
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  depends_on = [data.aws_internet_gateway.IGW]

  tags = {
    Environment = "WP-ALB"
  }

}

resource "aws_alb_target_group" "targ" {
  name   = "WP-TargetGroup"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 30
    port                = 80
    matcher             = "200-399"
  }
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
}



resource "aws_alb_target_group_attachment" "attach_web1" {
  target_group_arn = aws_alb_target_group.targ.arn
  target_id = aws_instance.wp-serverA.id
  port = 80
}

resource "aws_alb_target_group_attachment" "attach_web2" {
  target_group_arn = aws_alb_target_group.targ.arn
  target_id = aws_instance.wp-serverB.id
  port = 80
}

resource "aws_alb_listener" "list" {
  default_action {
    target_group_arn = aws_alb_target_group.targ.arn
    type = "forward"
  }
  load_balancer_arn = aws_alb.alb.arn
  port = 80
}
