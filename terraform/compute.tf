# Getting the latest AMI
data "aws_ami" "latest_amzn_linux" {
  most_recent  = true
  owners       = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  } 
}

# Instance template for ASG
resource "aws_launch_template" "app_lt" {
  name_prefix            = "app_server_lt"
  image_id               = data.aws_ami.latest_amzn_linux.id
  instance_type          = var.instance_type
  user_data              = filebase64("${path.module}/userdata.tpl")
  vpc_security_group_ids = [aws_security_group.asg_config_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.sm-profile.name
  }
}

resource "aws_autoscaling_group" "asg" {
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  health_check_type    = "EC2"
  target_group_arns    = [aws_lb_target_group.alb_tg.arn]
  vpc_zone_identifier = [ for subnet in aws_subnet.private : subnet.id ]

  launch_template {
      id = aws_launch_template.app_lt.id
    }

  tag {
    key                 = "Name"
    value               = "App-ASG"
    propagate_at_launch = true
  }
}