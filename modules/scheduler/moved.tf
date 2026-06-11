moved {
  from = aws_scheduler_schedule.scheduled_log
  to   = aws_scheduler_schedule.this["scheduled-log"]
}

moved {
  from = aws_ecs_task_definition.bootstrap
  to   = aws_ecs_task_definition.bootstrap["scheduled-log"]
}
