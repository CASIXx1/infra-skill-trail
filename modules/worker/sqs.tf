resource "aws_sqs_queue" "worker_dlq" {
  name                      = "${var.name}-worker-dlq"
  message_retention_seconds = var.message_retention_seconds
}

resource "aws_sqs_queue" "worker" {
  name                       = "${var.name}-worker"
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.worker_dlq.arn
    maxReceiveCount     = var.max_receive_count
  })
}
