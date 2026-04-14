# -------------------------------
# IAM ROLE FOR EC2 (Beanstalk)
# -------------------------------
resource "aws_iam_role" "eb_instance_role" {
  name = "timesheet-eb-instance-role-v1997"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "timesheet-eb-instance-profile-v1997"
  role = aws_iam_role.eb_instance_role.name
}

# -------------------------------
# SERVICE ROLE
# -------------------------------
resource "aws_iam_role" "eb_service_role" {
  name = "timesheet-eb-service-role-v1997"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eb_service_policy" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# -------------------------------
# APPLICATION
# -------------------------------
resource "aws_elastic_beanstalk_application" "app" {
  name = "timesheet-app-v1997"
}

# -------------------------------
# ENVIRONMENT
# -------------------------------
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "timesheet-env-v1997"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.12.1 running Python 3.11"

  # INSTANCE PROFILE
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  # INSTANCE TYPE
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  # SECURITY GROUP
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.security_group_id
  }

  # SERVICE ROLE
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }

  # SINGLE INSTANCE
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  # VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  # PRIVATE SUBNETS
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.private_subnet_ids)
  }

  # NO PUBLIC IP
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  # HEALTH CHECK
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "basic"
  }

  # RDS HOSTNAME
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
