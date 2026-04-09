output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_name" {
  value = "timesheetdb"
}