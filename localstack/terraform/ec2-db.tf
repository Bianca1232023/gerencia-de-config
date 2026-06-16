# EC2 do banco de dados PostgreSQL — subnet privada
resource "aws_instance" "db" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.dating_app.key_name
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {
    Name    = "dating-app-db"
    Project = "dating-app"
    Role    = "db"
  }
}
