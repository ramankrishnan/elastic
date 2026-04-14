output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_db_name" {
  description = "RDS database name"
  value       = module.rds.rds_db_name
}

output "beanstalk_url" {
  description = "Beanstalk environment URL"
  value       = module.beanstalk.environment_url
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "security_group_id" {
  description = "Beanstalk security group ID"
  value       = module.security_group.security_group_id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = module.security_group.rds_security_group_id
}
