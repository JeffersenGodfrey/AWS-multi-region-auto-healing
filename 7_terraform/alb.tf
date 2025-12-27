################################
# Target Group
################################
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name = "web-target-group"
  }
}

################################
# Application Load Balancer
################################
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "web-alb"
  }
}

################################
# Listener (HTTP :80)
################################
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}


resource "aws_lb" "secondary_alb" {
  provider           = aws.secondary
  name               = "secondary-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.secondary_public_1.id,
    aws_subnet.secondary_public_2.id
  ]
  security_groups = [aws_security_group.alb_sg_secondary.id]
}
