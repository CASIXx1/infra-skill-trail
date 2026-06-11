output "name" {
  description = "EventBridge Scheduler schedule name."
  value       = "${var.name}-scheduled-log"
}

output "arn" {
  description = "EventBridge Scheduler schedule ARN."
  value       = aws_scheduler_schedule.scheduled_log.arn
}

output "role_arn" {
  description = "IAM role ARN assumed by EventBridge Scheduler."
  value       = aws_iam_role.this.arn
}

output "task_definition_family" {
  description = "ECS task definition family launched by EventBridge Scheduler."
  value       = var.task_definition_family
}

output "task_definition_arn" {
  description = "ECS task definition family ARN used for Scheduler IAM scoping."
  value       = local.task_definition_arn
}
