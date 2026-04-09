variable "vpc_id" {
  description = "VPC ID for Beanstalk"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for Beanstalk"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for Beanstalk"
  type        = string
}