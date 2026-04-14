output "security_group_id" {
  description = "Security Group ID for Elastic Beanstalk"
  value       = aws_security_group.beanstalk_sg.id
}

output "rds_security_group_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds_sg.id
}
