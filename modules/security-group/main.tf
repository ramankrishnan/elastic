
# =========================
# BEANSTALK SECURITY GROUP
# =========================
resource "aws_security_group" "beanstalk_sg" {
  name        = "timesheet-beanstalk-sg"
  description = "Security group for Elastic Beanstalk instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Django App"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "timesheet-beanstalk-sg"
  }
}

# =========================
# RDS SECURITY GROUP
# =========================
resource "aws_security_group" "rds_sg" {
  name        = "timesheet-rds-sg"
  description = "Security group for RDS MySQL database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from Beanstalk"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.beanstalk_sg.id]
  }

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "timesheet-rds-sg"
  }
}
