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

output "db_instance_id" {
  description = "ID da instância EC2 do banco de dados"
  value       = aws_instance.db.id
}

output "db_private_ip" {
  description = "IP privado da EC2 do banco de dados"
  value       = aws_instance.db.private_ip
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_api_gateway_rest_api.dating_app.id
}

output "api_gateway_url" {
  description = "URL do API Gateway no LocalStack"
  value       = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.dating_app.id}/${aws_api_gateway_stage.prod.stage_name}/_user_request_"
}
