output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_database_name" {
  description = "Database name"
  value       = aws_db_instance.mysql.db_name
}

output "rds_username" {
  description = "Master username"
  value       = aws_db_instance.mysql.username
}

output "rds_password" {
  description = "Master password (hardcoded)"
  value       = "StrongPassword123"
  sensitive   = true
}

output "rds_port" {
  description = "Database port"
  value       = aws_db_instance.mysql.port
}

