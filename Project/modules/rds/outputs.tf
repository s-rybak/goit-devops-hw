output "db_endpoint" {
  description = "Endpoint створеної RDS бази (standalone або Aurora)."
  value       = try(aws_db_instance.standard[0].endpoint, aws_rds_cluster.aurora[0].endpoint)
}

output "db_security_group_id" {
  description = "ID security group, яка використовується для доступу до RDS."
  value       = aws_security_group.rds.id
}

output "db_host" {
  description = "Hostname бази даних (без порту)"
  value       = try(aws_db_instance.standard[0].address, aws_rds_cluster.aurora[0].endpoint)
}

output "db_port" {
  description = "Port бази даних"
  value       = try(aws_db_instance.standard[0].port, aws_rds_cluster.aurora[0].port)
}

output "db_name" {
  description = "Назва бази даних"
  value       = var.db_name
}

output "db_username" {
  description = "Username для підключення"
  value       = var.username
}

output "db_password" {
  description = "Password для підключення"
  value       = var.password
  sensitive   = true
}