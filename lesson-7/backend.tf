# Налаштування бекенду Terraform (S3 + DynamoDB) для збереження стану.
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-goithw-rybak" # Назва S3-бакета
#     key            = "lesson-5/terraform.tfstate"   # Шлях до файлу стейту
#     region         = "us-east-1"                    # Регіон AWS
#     dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB
#     encrypt        = true                           # Шифрування файлу стейту
#     profile        = "goithw"                       # Профіль AWS
#   }
# }

