resource "aws_db_subnet_group" "db_subnets" {
  name = "db_subnets"
  subnet_ids = [ for subnet in aws_subnet.private : subnet.id ]

  tags = {
    Name = "db_subnets"
  }
}

resource "aws_db_instance" "app_1_db" {
  allocated_storage      = 20
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
}

### STORING DATABASE CREDENTIALS IN SECRETS MANAGER
resource "aws_secretsmanager_secret" "db_username" {
  name        = "db_username"
  description = "Database Username"
}

resource "aws_secretsmanager_secret_version" "db_username" {
  secret_id     = aws_secretsmanager_secret.db_username.id
  secret_string = var.db_username
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "db_password"
  description = "Database Password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}