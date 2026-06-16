# ============================================================
# Makefile — Dating App LocalStack
# ============================================================

MAKEFILE_DIR  := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
WORKSPACE_ROOT := $(abspath $(MAKEFILE_DIR)/..)

.PHONY: all setup setup-keys up down logs \
        tf-init tf-plan tf-apply tf-destroy tf-output \
        ansible-ping ansible-db ansible-api ansible-all \
        clean

# ============================================================
# Fluxo completo
# ============================================================
all: setup up tf-apply ansible-all
	@echo ""
	@echo "==================================================="
	@echo "  Setup completo!"
	@echo "==================================================="
	@echo "  API (direto):       http://localhost:3000"
	@echo "  LocalStack health:  http://localhost:4566/_localstack/health"
	@echo "  API Gateway URL:    execute 'make tf-output'"
	@echo "==================================================="

# ============================================================
# Chaves SSH (pré-requisito para docker build)
# ============================================================
setup: setup-keys

setup-keys:
	@echo "--- Gerando chaves SSH ---"
	@mkdir -p ansible/keys
	@if [ ! -f ansible/keys/localstack ]; then \
		ssh-keygen -t ed25519 -C "localstack-dating-app" \
			-f ansible/keys/localstack -N "" ; \
		echo "Chaves geradas em ansible/keys/"; \
	else \
		echo "Chaves SSH já existem (ansible/keys/localstack)."; \
	fi
	@cp ansible/keys/localstack.pub docker/authorized_keys
	@echo "Chave pública copiada para docker/authorized_keys"

# ============================================================
# Docker
# ============================================================
up: setup-keys
	@echo "--- Subindo containers (LocalStack + EC2 simulados) ---"
	docker-compose up -d --build
	@echo "--- Aguardando LocalStack ficar disponível (até 60s) ---"
	@timeout 60 bash -c \
		'until curl -sf http://localhost:4566/_localstack/health | grep -q "available" 2>/dev/null; \
		 do echo "  aguardando LocalStack..."; sleep 5; done' \
	  || echo "Aviso: LocalStack pode não ter inicializado completamente."
	@echo "--- Aguardando SSH dos containers ficarem prontos (10s) ---"
	@sleep 10
	@echo "Containers prontos."

down:
	@echo "--- Derrubando todos os serviços ---"
	docker-compose down -v

logs:
	docker-compose logs -f

# ============================================================
# Terraform
# ============================================================
tf-init:
	@echo "--- Inicializando Terraform ---"
	cd terraform && terraform init

tf-plan: tf-init
	@echo "--- Planejando infraestrutura ---"
	cd terraform && terraform plan

tf-apply: tf-init
	@echo "--- Aplicando infraestrutura no LocalStack ---"
	cd terraform && terraform apply -auto-approve

tf-destroy:
	@echo "--- Destruindo infraestrutura no LocalStack ---"
	cd terraform && terraform destroy -auto-approve

tf-output:
	@echo "--- Outputs do Terraform ---"
	cd terraform && terraform output

# ============================================================
# Ansible
# ============================================================
ansible-ping:
	@echo "--- Testando conectividade SSH com os containers ---"
	cd ansible && ansible all -i inventory/hosts.ini -m ping

ansible-db:
	@echo "--- Configurando banco de dados (PostgreSQL + schema + seeds) ---"
	cd ansible && ansible-playbook -i inventory/hosts.ini playbook-db.yml

ansible-api:
	@echo "--- Fazendo deploy da API Node.js ---"
	cd ansible && ansible-playbook -i inventory/hosts.ini playbook-api.yml

ansible-all:
	@echo "--- Executando todos os playbooks Ansible ---"
	cd ansible && ansible-playbook -i inventory/hosts.ini site.yml

# ============================================================
# Limpeza completa
# ============================================================
clean: down
	@echo "--- Removendo artefatos gerados ---"
	rm -f docker/authorized_keys
	rm -rf terraform/.terraform \
	       terraform/terraform.tfstate \
	       terraform/terraform.tfstate.backup \
	       terraform/.terraform.lock.hcl
	@echo "Limpeza concluída."
