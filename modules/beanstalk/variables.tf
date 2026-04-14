variable "vpc_id" {
  description = "VPC ID for Beanstalk"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Beanstalk"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for Beanstalk"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS database endpoint (hostname without port)"
  type        = string
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_port" {
  description = "RDS database port"
  type        = string
  default     = "3306"
}
