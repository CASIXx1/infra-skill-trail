resource "aws_security_group" "this" {
  name        = "${var.name}-cache"
  description = "Security group for ElastiCache."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-cache"
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_ecs_tasks" {
  security_group_id            = aws_security_group.this.id
  description                  = "Valkey traffic from ECS tasks."
  from_port                    = var.port
  to_port                      = var.port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.ecs_task_security_group_id
}
