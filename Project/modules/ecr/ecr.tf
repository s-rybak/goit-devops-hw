# Створення репозиторію Amazon ECR.
resource "aws_ecr_repository" "repository" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  # Налаштування автоматичного сканування образів при push
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Налаштування шифрування
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = var.ecr_name
    Environment = "lesson-5"
    ManagedBy   = "Terraform"
  }
}

# Політика доступу для репозиторію ECR
resource "aws_ecr_repository_policy" "repository_policy" {
  repository = aws_ecr_repository.repository.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPushPull"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DescribeImages"
        ]
      }
    ]
  })
}
