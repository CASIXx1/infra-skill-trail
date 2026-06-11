resource "aws_sns_topic" "scheduled_notifications" {
  name = "${var.name}-scheduled-notifications"
}

resource "aws_sns_topic_subscription" "scheduled_notification_email" {
  topic_arn = aws_sns_topic.scheduled_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
