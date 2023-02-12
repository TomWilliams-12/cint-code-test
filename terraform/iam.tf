### Creating IAM role for the ASG instances to have access to secrets manager for the DB credentials

resource "aws_iam_role" "sm_role" {
  name = "secrets_manager_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "sm_policy" {
  name = "secrets_manager_policy"
  role = aws_iam_role.sm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "sm-profile" {
    name = "secrets-manager-profile"
    role = aws_iam_role.sm_role.name
}