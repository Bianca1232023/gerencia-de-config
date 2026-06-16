# ============================================================
# DB Subnet Group — RDS exige pelo menos 2 subnets em AZs distintas
# ============================================================
resource "aws_db_subnet_group" "main" {
  name        = "dating-app-db-subnet-group"
  description = "Subnet group para o RDS PostgreSQL do Dating App"
  subnet_ids  = [aws_subnet.private.id, aws_subnet.private2.id]

  tags = {
    Name    = "dating-app-db-subnet-group"
    Project = "dating-app"
  }
}

# ============================================================
# RDS PostgreSQL — subnet privada
# ============================================================
resource "aws_db_instance" "postgres" {
  identifier     = "dating-app-db"
  engine         = "postgres"
  engine_version = "14"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name    = "dating-app-rds"
    Project = "dating-app"
    Role    = "db"
  }
}
