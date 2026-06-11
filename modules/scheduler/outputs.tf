output "name" {
  description = "EventBridge Scheduler schedule names keyed by job key."
  value       = { for key in keys(var.task_definitions) : key => "${var.name}-${key}" }
}

output "arn" {
  description = "EventBridge Scheduler schedule ARNs keyed by job key."
  value       = { for key, schedule in aws_scheduler_schedule.this : key => schedule.arn }
}

output "role_arn" {
  description = "IAM role ARN assumed by EventBridge Scheduler."
  value       = aws_iam_role.this.arn
}

output "task_definition_family" {
  description = "ECS task definition families launched by EventBridge Scheduler."
  value       = { for key, task_definition in var.task_definitions : key => task_definition.family }
}

output "task_definition_arn" {
  description = "ECS task definition family ARNs used for Scheduler IAM scoping."
  value       = local.task_definition_arns
}

output "notification_topic_arn" {
  description = "SNS topic ARN for scheduled notification jobs."
  value       = aws_sns_topic.scheduled_notifications.arn
}
