resource "aws_security_group" "app_1_alb" {
    name = "app-1-alb-sg"
    description = "App-1 SG - Allow connections on Port 80"
    vpc_id      = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "asg_config_sg" {
  name        = "asg_config_sg"
  description = "Security group for autoscaling"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [ aws_security_group.app_1_alb.id ]
  }

  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "rds_sg" {
    name        = "rds_sg"
    description = "Security group for database communication"
    vpc_id      = aws_vpc.main.id

    ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    security_groups = [ aws_security_group.asg_config_sg.id ]
    }
    egress {
          from_port = 0
          to_port = 0
          protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]
      }
}