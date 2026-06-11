output "queue_name" {
  description = "Worker SQS queue name."
  value       = aws_sqs_queue.worker.name
}

output "queue_url" {
  description = "Worker SQS queue URL."
  value       = aws_sqs_queue.worker.url
}

output "queue_arn" {
  description = "Worker SQS queue ARN."
  value       = aws_sqs_queue.worker.arn
}

output "dlq_name" {
  description = "Worker SQS dead-letter queue name."
  value       = aws_sqs_queue.worker_dlq.name
}

output "dlq_url" {
  description = "Worker SQS dead-letter queue URL."
  value       = aws_sqs_queue.worker_dlq.url
}

output "dlq_arn" {
  description = "Worker SQS dead-letter queue ARN."
  value       = aws_sqs_queue.worker_dlq.arn
}

output "task_role_arn" {
  description = "Worker ECS task role ARN."
  value       = aws_iam_role.task.arn
}

output "task_role_name" {
  description = "Worker ECS task role name."
  value       = aws_iam_role.task.name
}
