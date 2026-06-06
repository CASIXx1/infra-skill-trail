resource "aws_security_group" "aurora" {
  name        = "${var.name}-aurora"
  description = "Security group for Aurora PostgreSQL."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-aurora"
  }
}

resource "aws_vpc_security_group_ingress_rule" "aurora_from_ecs_tasks" {
  security_group_id            = aws_security_group.aurora.id
  description                  = "PostgreSQL from ECS tasks."
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.ecs_task_security_group_id
}
