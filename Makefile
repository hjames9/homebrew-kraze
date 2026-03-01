.PHONY: help update-version update-hashes update-all verify clean

# Variables
FORMULA_FILE := Formula/kraze.rb
GITHUB_REPO := hjames9/kraze
TMP_DIR := /tmp/kraze-homebrew-update

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help:
	@echo "Homebrew Formula Update Makefile for kraze"
	@echo ""
	@echo "Usage:"
	@echo "  make update-version VERSION=x.y.z    Update version number in formula"
	@echo "  make update-hashes VERSION=x.y.z     Update SHA256 hashes for binaries"
	@echo "  make update-all VERSION=x.y.z        Update both version and hashes"
	@echo "  make verify                          Verify formula syntax"
	@echo "  make clean                           Clean temporary files"
	@echo ""
	@echo "Example:"
	@echo "  make update-all VERSION=0.7.0"

update-version:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)ERROR: VERSION is required$(NC)"; \
		echo "Usage: make update-version VERSION=x.y.z"; \
		exit 1; \
	fi
	@echo "$(GREEN)Updating version to $(VERSION)...$(NC)"
	@sed -i.bak 's/version "[^"]*"/version "$(VERSION)"/' $(FORMULA_FILE)
	@rm -f $(FORMULA_FILE).bak
	@echo "$(GREEN)Version updated successfully$(NC)"

update-hashes:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)ERROR: VERSION is required$(NC)"; \
		echo "Usage: make update-hashes VERSION=x.y.z"; \
		exit 1; \
	fi
	@echo "$(GREEN)Updating hashes for version $(VERSION)...$(NC)"
	@mkdir -p $(TMP_DIR)

	@echo "$(YELLOW)Downloading darwin-arm64 binary...$(NC)"
	@curl -L -o $(TMP_DIR)/kraze-darwin-arm64 \
		https://github.com/$(GITHUB_REPO)/releases/download/v$(VERSION)/kraze-v$(VERSION)-darwin-arm64
	@ARM64_HASH=$$(sha256sum $(TMP_DIR)/kraze-darwin-arm64 | awk '{print $$1}'); \
	echo "$(GREEN)ARM64 SHA256: $$ARM64_HASH$(NC)"; \
	awk -v hash="$$ARM64_HASH" '/on_arm/,/end/ { if (/sha256/) { sub(/"[^"]*"/, "\"" hash "\""); found=1 } } {print} END {if (!found) exit 1}' $(FORMULA_FILE) > $(TMP_DIR)/formula.tmp && mv $(TMP_DIR)/formula.tmp $(FORMULA_FILE)

	@echo "$(YELLOW)Downloading darwin-amd64 binary...$(NC)"
	@curl -L -o $(TMP_DIR)/kraze-darwin-amd64 \
		https://github.com/$(GITHUB_REPO)/releases/download/v$(VERSION)/kraze-v$(VERSION)-darwin-amd64
	@AMD64_HASH=$$(sha256sum $(TMP_DIR)/kraze-darwin-amd64 | awk '{print $$1}'); \
	echo "$(GREEN)AMD64 SHA256: $$AMD64_HASH$(NC)"; \
	awk -v hash="$$AMD64_HASH" '/on_intel/,/end/ { if (/sha256/) { sub(/"[^"]*"/, "\"" hash "\""); found=1 } } {print} END {if (!found) exit 1}' $(FORMULA_FILE) > $(TMP_DIR)/formula.tmp && mv $(TMP_DIR)/formula.tmp $(FORMULA_FILE)

	@rm -rf $(TMP_DIR)
	@echo "$(GREEN)Hashes updated successfully$(NC)"

update-all:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)ERROR: VERSION is required$(NC)"; \
		echo "Usage: make update-all VERSION=x.y.z"; \
		exit 1; \
	fi
	@echo "$(GREEN)Updating formula to version $(VERSION)...$(NC)"
	@$(MAKE) update-version VERSION=$(VERSION)
	@$(MAKE) update-hashes VERSION=$(VERSION)
	@echo "$(GREEN)Formula updated successfully to version $(VERSION)$(NC)"
	@echo ""
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "  1. Review changes: git diff $(FORMULA_FILE)"
	@echo "  2. Verify formula: make verify"
	@echo "  3. Commit changes: git add $(FORMULA_FILE) && git commit -m 'Upgrade kraze to $(VERSION)'"

verify:
	@echo "$(YELLOW)Verifying formula syntax...$(NC)"
	@if command -v brew >/dev/null 2>&1; then \
		brew audit --strict $(FORMULA_FILE) || true; \
		brew style $(FORMULA_FILE) || true; \
		echo "$(GREEN)Formula verification complete$(NC)"; \
	else \
		echo "$(YELLOW)Homebrew not installed, skipping verification$(NC)"; \
	fi

clean:
	@echo "$(YELLOW)Cleaning temporary files...$(NC)"
	@rm -rf $(TMP_DIR)
	@rm -f $(FORMULA_FILE).bak $(FORMULA_FILE).bak1 $(FORMULA_FILE).bak2
	@echo "$(GREEN)Clean complete$(NC)"
