# Par de chaves SSH — gerado pelo Makefile (make setup-keys)
resource "aws_key_pair" "dating_app" {
  key_name   = var.key_name
  public_key = file("${path.module}/../ansible/keys/localstack.pub")

  tags = {
    Name    = "dating-app-keypair"
    Project = "dating-app"
  }
}

# EC2 da API Node.js — subnet pública
resource "aws_instance" "api" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.dating_app.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.api.id]

  tags = {
    Name    = "dating-app-api"
    Project = "dating-app"
    Role    = "api"
  }
}
