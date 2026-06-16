# ============================================================
# API Gateway REST API — proxy HTTP para a EC2 da API
# ============================================================
resource "aws_api_gateway_rest_api" "dating_app" {
  name        = "dating-app-gateway"
  description = "API Gateway para a Dating App — proxy para a EC2 da API Node.js"

  tags = {
    Name    = "dating-app-gateway"
    Project = "dating-app"
  }
}

# ============================================================
# Resource /{proxy+} — captura todas as rotas
# ============================================================
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.dating_app.id
  parent_id   = aws_api_gateway_rest_api.dating_app.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.dating_app.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_any" {
  rest_api_id             = aws_api_gateway_rest_api.dating_app.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.api_internal_url}/{proxy}"
}

# ============================================================
# Resource raiz /
# ============================================================
resource "aws_api_gateway_method" "root_any" {
  rest_api_id   = aws_api_gateway_rest_api.dating_app.id
  resource_id   = aws_api_gateway_rest_api.dating_app.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_any" {
  rest_api_id             = aws_api_gateway_rest_api.dating_app.id
  resource_id             = aws_api_gateway_rest_api.dating_app.root_resource_id
  http_method             = aws_api_gateway_method.root_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.api_internal_url}/"
}

# ============================================================
# Deployment e Stage prod
# ============================================================
resource "aws_api_gateway_deployment" "dating_app" {
  depends_on = [
    aws_api_gateway_integration.proxy_any,
    aws_api_gateway_integration.root_any,
  ]

  rest_api_id = aws_api_gateway_rest_api.dating_app.id
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.dating_app.id
  rest_api_id   = aws_api_gateway_rest_api.dating_app.id
  stage_name    = "prod"

  tags = {
    Name    = "dating-app-gateway-prod"
    Project = "dating-app"
  }
}
