# Dating App — Infraestrutura LocalStack

Simulação da infraestrutura AWS com **LocalStack**, **Terraform** e **Ansible** para rodar a API localmente sem custos de cloud.

## Arquitetura

```
       Internet
          │
    [API Gateway]  ← LocalStack (simulado)
          │  HTTP_PROXY
    [EC2 API]      ← Container Docker ec2-api (porta 3000)
          │
    [EC2 DB]       ← Container Docker ec2-db (porta 5432)
```

### Recursos AWS simulados no LocalStack

| Recurso | Tipo | Descrição |
|---------|------|-----------|
| VPC | `10.0.0.0/16` | Rede principal |
| Subnet pública | `10.0.1.0/24` | Subnet da API |
| Subnet privada | `10.0.2.0/24` | Subnet do banco de dados |
| Internet Gateway | — | Saída da VPC |
| Security Group API | — | Libera porta 3000 (externa) e 22 (interna) |
| Security Group DB | — | Libera porta 5432 apenas da API |
| Key Pair | — | Chave SSH para as instâncias |
| EC2 API | `t2.micro` | Instância simulada da API |
| EC2 DB | `t2.micro` | Instância simulada do banco |
| API Gateway | REST API | Proxy HTTP para a EC2 da API |

## Pré-requisitos

| Ferramenta | Versão mínima |
|------------|--------------|
| [Docker](https://docs.docker.com/get-docker/) + Docker Compose | Docker 24+ |
| [Terraform](https://developer.hashicorp.com/terraform/install) | >= 1.5 |
| [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) | >= 2.12 |
| `ssh-keygen` | padrão macOS/Linux |

## Estrutura do projeto

```
localstack/
├── docker-compose.yml          # LocalStack + containers EC2 simulados
├── Makefile                    # Automação de todos os comandos
├── docker/
│   └── Dockerfile.ec2          # Imagem Ubuntu 22.04 com SSH (simula EC2)
├── terraform/
│   ├── providers.tf            # Provider AWS apontando para localhost:4566
│   ├── variables.tf            # Variáveis configuráveis
│   ├── network.tf              # VPC, subnets, Security Groups, Internet Gateway
│   ├── ec2-api.tf              # EC2 da API + Key Pair
│   ├── ec2-db.tf               # EC2 do banco de dados
│   ├── gateway.tf              # API Gateway REST com integração HTTP_PROXY
│   └── outputs.tf              # Outputs (IPs, IDs, URL do Gateway)
└── ansible/
    ├── ansible.cfg             # Configuração: desativa host key checking, define chave SSH
    ├── inventory/
    │   └── hosts.ini           # ec2-api → 127.0.0.1:2222 | ec2-db → 127.0.0.1:2223
    ├── group_vars/
    │   └── all.yml             # Variáveis globais (DB, API, Node.js)
    ├── site.yml                # Playbook principal (DB → API)
    ├── playbook-db.yml         # Deploy do banco de dados
    ├── playbook-api.yml        # Deploy da API
    ├── keys/                   # Chaves SSH (geradas pelo make setup-keys, não versionadas)
    └── roles/
        ├── db/
        │   ├── tasks/main.yml  # Instalar PostgreSQL, criar DB, executar schema e seeds
        │   ├── handlers/main.yml
        │   └── files/
        │       ├── schema.sql  # DDL: cria todas as tabelas (IF NOT EXISTS)
        │       └── seeds.sql   # Dados iniciais: usuários, interesses, matches, mensagens
        └── api/
            ├── tasks/main.yml  # Instalar Node.js 20, PM2, copiar código, criar .env, iniciar
            └── templates/
                └── env.j2      # Template do arquivo .env da API
```

## Como usar

### Setup completo (recomendado)

```bash
cd localstack
make all
```

Este comando executa automaticamente na sequência:
1. Gera par de chaves SSH em `ansible/keys/`
2. Sobe os containers Docker (LocalStack + EC2 simulados)
3. Aplica a infraestrutura Terraform no LocalStack
4. Configura o banco de dados via Ansible (PostgreSQL + schema + seeds)
5. Faz o deploy da API via Ansible (Node.js + PM2)

---

### Passo a passo (controle manual)

```bash
# 1. Gerar chaves SSH e subir containers
make up

# 2. Aplicar infraestrutura no LocalStack
make tf-apply

# 3. Ver URL do API Gateway e outros outputs
make tf-output

# 4. Testar conectividade SSH com os containers
make ansible-ping

# 5. Configurar o banco de dados (PostgreSQL + schema + seeds)
make ansible-db

# 6. Fazer deploy da API
make ansible-api
```

---

### Testar a API

**Acesso direto ao container:**
```bash
curl http://localhost:3000/usuarios
curl http://localhost:3000/interesses
curl http://localhost:3000/matches
```

**Acesso via API Gateway (LocalStack):**
```bash
# Obtenha a URL gerada:
make tf-output

# Use a URL exibida em "api_gateway_url", ex:
curl http://localhost:4566/restapis/<id>/prod/_user_request_/usuarios
```

---

### Derrubar os serviços

```bash
make down
```

### Limpeza completa (containers + estado Terraform)

```bash
make clean
```

---

## Observações

- O LocalStack simula as chamadas de API da AWS; as **instâncias EC2 não executam código real** — quem roda o código são os containers Docker `ec2-api` e `ec2-db`.
- As chaves SSH em `ansible/keys/` são ignoradas pelo `.gitignore` e **não devem ser versionadas**.
- Para ver os logs da API em tempo real:
  ```bash
  docker exec -it ec2-api pm2 logs
  ```
- Para acessar o banco de dados diretamente:
  ```bash
  docker exec -it ec2-db psql -U dating_user -d dating_app
  ```
- Para reexecutar apenas as seeds:
  ```bash
  docker exec -it ec2-db psql -U dating_user -d dating_app -f /tmp/seeds.sql
  ```
