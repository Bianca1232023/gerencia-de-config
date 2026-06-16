variable "region" {
  description = "Região AWS simulada no LocalStack"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC principal"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block da subnet pública (API)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block da subnet privada (banco de dados)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ami_id" {
  description = "ID da AMI para as instâncias EC2 (LocalStack aceita qualquer valor)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nome do par de chaves SSH registrado no LocalStack"
  type        = string
  default     = "dating-app-key"
}

variable "db_name" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "dating_app"
}

variable "db_user" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "dating_user"
}

variable "db_password" {
  description = "Senha do banco de dados (use tfvars ou variável de ambiente em produção)"
  type        = string
  default     = "dating_pass_2024"
  sensitive   = true
}

variable "api_port" {
  description = "Porta da API Node.js"
  type        = number
  default     = 3000
}

variable "api_internal_url" {
  description = "URL interna da API para integração com o API Gateway (nome do container Docker)"
  type        = string
  default     = "http://ec2-api:3000"
}
