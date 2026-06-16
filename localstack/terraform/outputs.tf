output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID da subnet pública (API)"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID da subnet privada (DB)"
  value       = aws_subnet.private.id
}

output "api_instance_id" {
  description = "ID da instância EC2 da API"
  value       = aws_instance.api.id
}

output "api_public_ip" {
  description = "IP público da EC2 da API (simulado pelo LocalStack)"
  value       = aws_instance.api.public_ip
}

output "rds_endpoint" {
  description = "Endereço do RDS PostgreSQL (sem porta)"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "Porta do RDS PostgreSQL"
  value       = aws_db_instance.postgres.port
}

output "rds_db_name" {
  description = "Nome do banco de dados RDS"
  value       = aws_db_instance.postgres.db_name
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_api_gateway_rest_api.dating_app.id
}

output "api_gateway_url" {
  description = "URL do API Gateway no LocalStack"
  value       = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.dating_app.id}/${aws_api_gateway_stage.prod.stage_name}/_user_request_"
}
