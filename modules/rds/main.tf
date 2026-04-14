# -------------------------------
# ENVIRONMENT
# -------------------------------
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "timesheet-env-v1997"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.11.0 running Python 3.11"

  # ... (keep all your existing settings) ...

  # 🔴 ADD THESE RDS CONNECTION SETTINGS 🔴
  
  # RDS ENDPOINT
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = var.rds_endpoint
  }

  # RDS DATABASE NAME
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = var.rds_db_name
  }

  # RDS USERNAME
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = var.rds_username
  }

  # RDS PASSWORD
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = var.rds_password
  }

  # RDS PORT
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"
    value     = var.rds_port
  }
}
