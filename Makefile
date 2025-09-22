.PHONY: help
help: # Show available recipes
	@echo "Recipes:"
	@grep --extended-regexp "^[a-z-]+: # " "$(word 1,$(MAKEFILE_LIST))" | \
		awk 'BEGIN {FS = ": # "}; {printf "\t%s:  %s\n", $$1, $$2}' | \
			{ command -v column >/dev/null 2>&1 && column -s : -t || cat; }

.PHONY: build
build: # Build image and catalog
	@go run ./cmd/build --tools onlyoffice-docspace-4testing
	@go run ./cmd/catalog onlyoffice-docspace-4testing

.PHONY: import
import: # Import catalog to Docker MCP
	@docker mcp catalog import "$(CURDIR)/catalogs/onlyoffice-docspace-4testing/catalog.yaml"

.PHONY: i install
i: install
install: # Install tools and dependencies
	@mise install
	@go mod tidy

.PHONY: reset
reset: # Reset Docker MCP catalog
	@docker mcp catalog reset
