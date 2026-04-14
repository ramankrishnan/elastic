output "environment_url" {
  description = "Elastic Beanstalk environment URL"
  value       = aws_elastic_beanstalk_environment.env.endpoint_url
}

output "environment_name" {
  description = "Elastic Beanstalk environment name"
  value       = aws_elastic_beanstalk_environment.env.name
}

output "application_name" {
  description = "Elastic Beanstalk application name"
  value       = aws_elastic_beanstalk_application.app.name
}
