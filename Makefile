.DEFAULT_GOAL := help

.PHONY: help install-hooks validate

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_\/-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Code Quality

install-hooks: ## Install pre-commit hooks
	@command -v pre-commit >/dev/null 2>&1 || { \
		printf '%s\n' 'pre-commit is not installed. See https://pre-commit.com/#install'; \
		exit 1; \
	}
	pre-commit install --install-hooks

validate: ## Validate the shared Renovate preset
	RENOVATE_X_IGNORE_RE2=true npx --yes --package renovate@44.52.0 -- renovate-config-validator --strict --no-global default.json
