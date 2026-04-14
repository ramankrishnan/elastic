output "rds_endpoint" {
  description = "RDS endpoint hostname (without port)"
  value       = split(":", aws_db_instance.db.endpoint)[0]
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.db.port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = aws_db_instance.db.db_name
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.db.username
  sensitive   = true
}
