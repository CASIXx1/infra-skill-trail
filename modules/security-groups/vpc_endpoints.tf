resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.name}-vpce"
  description = "Allow HTTPS access to VPC interface endpoints."
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "All outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-vpce"
  }
}
