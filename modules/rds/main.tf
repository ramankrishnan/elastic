resource "aws_db_subnet_group" "db_subnet" {
  name       = "timesheet-db-subnet-group-yatish-v717"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "timesheet-db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "timesheetdb"
  username             = "admin8"
  password             = "Admin123478"
  skip_final_snapshot  = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false
}