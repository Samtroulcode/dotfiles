# Makefile for dotfiles repository management
.PHONY: help install lint test clean setup-hooks validate security docs

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies and setup development environment
	@echo "🔧 Setting up development environment..."
	@command -v pre-commit >/dev/null 2>&1 || pip install pre-commit
	@command -v shellcheck >/dev/null 2>&1 || (echo "Please install shellcheck: sudo apt-get install shellcheck" && exit 1)
	@pre-commit install
	@echo "✅ Development environment ready!"

setup-hooks: ## Install git hooks
	@echo "🪝 Installing git hooks..."
	@pre-commit install --hook-type pre-commit
	@pre-commit install --hook-type pre-push
	@echo "✅ Git hooks installed!"

lint: ## Run all linters
	@echo "🔍 Running linters..."
	@pre-commit run --all-files

lint-shell: ## Run shellcheck on all shell scripts
	@echo "🐚 Linting shell scripts..."
	@find . -name "*.sh" -type f -exec shellcheck {} +

test: ## Run tests (basic validation)
	@echo "🧪 Running tests..."
	@make validate
	@echo "✅ All tests passed!"

validate: ## Validate configuration files
	@echo "✅ Validating configuration files..."
	@find . -name "*.yml" -o -name "*.yaml" | while read -r file; do \
		echo "Validating $$file"; \
		python3 -c "import yaml; yaml.safe_load(open('$$file'))" || exit 1; \
	done
	@find . -name "*.json" -not -path "./.config/qutebrowser/*" -not -path "./.config/waybar/*" | while read -r file; do \
		echo "Validating $$file"; \
		python3 -c "import json; json.load(open('$$file'))" || exit 1; \
	done

security: ## Run security scans
	@echo "🔒 Running security scans..."
	@command -v detect-secrets >/dev/null 2>&1 || pip install detect-secrets
	@detect-secrets scan --baseline .secrets.baseline || echo "⚠️  Security scan found issues"

clean: ## Clean temporary files and caches
	@echo "🧹 Cleaning temporary files..."
	@find . -name "*.tmp" -delete
	@find . -name "*.log" -not -path "./.config/*" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Cleanup complete!"

backup: ## Create backup of important configurations
	@echo "💾 Creating backup..."
	@./scripts/backup_home_external.sh 2>/dev/null || echo "⚠️  Backup script not available or failed"

check-scripts: ## Check all scripts for common issues
	@echo "📋 Checking scripts for common issues..."
	@for script in scripts/*.sh .config/hypr/scripts/*.sh; do \
		if [ -f "$$script" ]; then \
			echo "Checking $$script"; \
			if grep -q "/home/sam" "$$script"; then \
				echo "⚠️  Found hardcoded path in $$script"; \
			fi; \
			if ! grep -q "set -e" "$$script" && ! grep -q "set -eu" "$$script"; then \
				echo "⚠️  Consider adding 'set -e' to $$script for better error handling"; \
			fi; \
		fi; \
	done

docs: ## Generate/update documentation
	@echo "📚 Updating documentation..."
	@echo "Current repository structure:" > STRUCTURE.md
	@tree -I '.git|.config' >> STRUCTURE.md 2>/dev/null || find . -type d -not -path "./.git*" -not -path "./.config*" | sort >> STRUCTURE.md
	@echo "✅ Documentation updated!"

check-deps: ## Check for missing dependencies
	@echo "🔍 Checking dependencies..."
	@echo "Required tools:"
	@echo -n "  shellcheck: "; command -v shellcheck >/dev/null 2>&1 && echo "✅" || echo "❌ Not installed"
	@echo -n "  pre-commit: "; command -v pre-commit >/dev/null 2>&1 && echo "✅" || echo "❌ Not installed"
	@echo -n "  python3: "; command -v python3 >/dev/null 2>&1 && echo "✅" || echo "❌ Not installed"
	@echo -n "  git: "; command -v git >/dev/null 2>&1 && echo "✅" || echo "❌ Not installed"

all: install lint test ## Run full setup and validation