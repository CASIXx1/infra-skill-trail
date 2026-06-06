resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-database"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.name}-database"
  }
}
