# -------------------------------
# IAM ROLE FOR EC2 (Beanstalk)
# -------------------------------
resource "aws_iam_role" "eb_instance_role" {
  name = "timesheet-eb-instance-role-v717"

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
  name = "timesheet-eb-instance-profile-v717"
  role = aws_iam_role.eb_instance_role.name
}

# -------------------------------
# SERVICE ROLE (VERY IMPORTANT)
# -------------------------------
resource "aws_iam_role" "eb_service_role" {
  name = "timesheet-eb-service-role-v717"

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
# ELASTIC BEANSTALK APPLICATION
# -------------------------------
resource "aws_elastic_beanstalk_application" "app" {
  name = "timesheet-app-v717"
}

# -------------------------------
# ELASTIC BEANSTALK ENVIRONMENT
# -------------------------------
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "timesheet-env-v717"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.11.0 running Python 3.11"

  # -------------------------------
  # INSTANCE PROFILE
  # -------------------------------
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

  # -------------------------------
  # SERVICE ROLE (IMPORTANT)
  # -------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }

  # -------------------------------
  # SINGLE INSTANCE (NO LOAD BALANCER)
  # -------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  # -------------------------------
  # VPC CONFIGURATION
  # -------------------------------
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  # PRIVATE SUBNET
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.private_subnet_id
  }

  # NO PUBLIC IP
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  # -------------------------------
  # HEALTH CHECK
  # -------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "basic"
  }
}