# =========================
# VARIABLES
# =========================
variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "timesheetdb"
}

# =========================
# VPC Module
# =========================
module "vpc" {
  source = "./modules/vpc"
}

# =========================
# Security Group Module
# =========================
module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
}

# =========================
# Database (RDS) - CREATE FIRST
# =========================
module "rds" {
  source = "./modules/rds"

  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_group.rds_security_group_id
  
  # Database credentials
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

# =========================
# Backend (Elastic Beanstalk) - DEPENDS ON RDS
# =========================
module "beanstalk" {
  source = "./modules/beanstalk"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_group.security_group_id

  # RDS CONNECTION DETAILS (from RDS module outputs)
  rds_endpoint = module.rds.rds_endpoint
  rds_db_name  = module.rds.rds_db_name
  rds_username = module.rds.rds_username
  rds_password = var.db_password
  rds_port     = tostring(module.rds.rds_port)
}

# =========================
# Frontend (S3)
# =========================
module "frontend" {
  source = "./modules/frontend"

  bucket_name = "timesheet-frontend-yatish-20240115-unique"
}
