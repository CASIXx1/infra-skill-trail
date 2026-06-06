resource "aws_rds_cluster" "this" {
  cluster_identifier          = "${var.name}-aurora"
  engine                      = "aurora-postgresql"
  engine_version              = var.engine_version
  database_name               = var.database_name
  master_username             = var.master_username
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  storage_encrypted = true

  tags = {
    Name = "${var.name}-aurora"
  }
}

resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.name}-aurora-writer"
  cluster_identifier = aws_rds_cluster.this.id
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  instance_class     = var.instance_class

  publicly_accessible = false

  tags = {
    Name = "${var.name}-aurora-writer"
  }
}

resource "aws_rds_cluster_instance" "reader" {
  identifier         = "${var.name}-aurora-reader"
  cluster_identifier = aws_rds_cluster.this.id
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  instance_class     = var.instance_class

  publicly_accessible = false

  tags = {
    Name = "${var.name}-aurora-reader"
  }
}
