output "api_log_group_name" {
  description = "CloudWatch Logs log group name for the API ECS service."
  value       = aws_cloudwatch_log_group.api.name
}

output "api_log_group_arn" {
  description = "CloudWatch Logs log group ARN for the API ECS service."
  value       = aws_cloudwatch_log_group.api.arn
}
