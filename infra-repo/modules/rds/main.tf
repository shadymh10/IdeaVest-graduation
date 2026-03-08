# ============================================
# RDS Module - PostgreSQL on Private Subnet
# ============================================

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"

  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  storage_type         = "gp3"
  storage_encrypted    = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.database_sg_id]

  multi_az            = false  # Free Tier
  publicly_accessible = false
  skip_final_snapshot = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Performance Insights (free for db.t3.micro)
  performance_insights_enabled = var.db_instance_class == "db.t3.micro" ? true : false

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}
