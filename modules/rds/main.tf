# -------------------------------
# RDS SUBNET GROUP
# -------------------------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "timesheet-rds-subnet-group-v1997"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "timesheet-rds-subnet-group"
  }
}

# -------------------------------
# RDS INSTANCE
# -------------------------------
resource "aws_db_instance" "db" {
  identifier              = "timesheet-db-v1997"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 0
  multi_az                = false

  tags = {
    Name = "timesheet-rds-instance"
  }
}
