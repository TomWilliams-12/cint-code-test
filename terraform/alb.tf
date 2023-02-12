resource "aws_lb_target_group" "alb_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 70
    timeout = 60
    matcher = 200
  }
}


resource "aws_lb" "alb" {
  name               = "app-1-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_1_alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  enable_deletion_protection = false

  tags = {
    AppName = "App-1"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}