# ============================================================
# VPC Principal
# ============================================================
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "dating-app-vpc"
    Project = "dating-app"
  }
}

# ============================================================
# Internet Gateway
# ============================================================
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "dating-app-igw"
    Project = "dating-app"
  }
}

# ============================================================
# Subnets
# ============================================================

# Subnet pública — API Node.js
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "dating-app-public-subnet"
    Project = "dating-app"
    Tier    = "public"
  }
}

# Subnet privada — banco de dados (AZ a)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name    = "dating-app-private-subnet"
    Project = "dating-app"
    Tier    = "private"
  }
}

# Segunda subnet privada — necessária para o DB Subnet Group do RDS (AZ b)
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name    = "dating-app-private-subnet-2"
    Project = "dating-app"
    Tier    = "private"
  }
}

# ============================================================
# Route Tables
# ============================================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "dating-app-public-rt"
    Project = "dating-app"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# Security Groups
# ============================================================

# SG da API — acesso externo na porta 3000
resource "aws_security_group" "api" {
  name        = "dating-app-api-sg"
  description = "Security Group da API Node.js"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.api_port
    to_port     = var.api_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso à API Node.js"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "SSH interno (Ansible)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Saída irrestrita"
  }

  tags = {
    Name    = "dating-app-api-sg"
    Project = "dating-app"
  }
}

# SG do banco de dados (RDS) — acesso restrito à API
resource "aws_security_group" "db" {
  name        = "dating-app-db-sg"
  description = "Security Group do RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
    description     = "PostgreSQL — acesso exclusivo da API"
  }

  # Range de portas usado pelo LocalStack para instâncias RDS internas
  ingress {
    from_port       = 4510
    to_port         = 4560
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
    description     = "LocalStack RDS — portas internas"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Saída irrestrita"
  }

  tags = {
    Name    = "dating-app-db-sg"
    Project = "dating-app"
  }
}
