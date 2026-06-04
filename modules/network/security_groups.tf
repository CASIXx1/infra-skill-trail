resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name}-ecs-tasks"
  description = "Security group for ECS tasks."
  vpc_id      = aws_vpc.this.id

  egress {
    description = "All outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ecs-tasks"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  description = "Security group for the public ALB."
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from the internet."
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTPS from the internet."
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs_tasks" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Application traffic to ECS tasks."
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_tasks.id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_tasks_from_alb" {
  security_group_id            = aws_security_group.ecs_tasks.id
  description                  = "Application traffic from the ALB."
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}
