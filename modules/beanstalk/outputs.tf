output "environment_url" {
  description = "Beanstalk application URL"
  value       = aws_elastic_beanstalk_environment.env.endpoint_url
}