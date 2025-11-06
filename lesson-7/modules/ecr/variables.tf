# Оголошення змінних модуля ecr.
variable "ecr_name" {
  description = "Ім'я репозиторію ECR"
  type        = string
}

variable "scan_on_push" {
  description = "Вмикає сканування на push"
  type        = bool
}