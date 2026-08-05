SHELL := /bin/bash
.DEFAULT_GOAL := help

DIR ?= .
CMD ?=
NN  ?= 01

.PHONY: help check lint doctor demo example chmod clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

check: lint doctor ## All quality gates (what CI runs)
	@python3 -m py_compile assets/drive.py && echo "drive.py: compiles"
	@python3 assets/drive.py --help >/dev/null && echo "drive.py: --help ok"
	@python3 -c "import sys; sys.path.insert(0, 'assets'); \
		import drive; s = drive.parse_script('6:ENTER 0.5:scan 1:CTRL_D'); \
		assert s == [(6.0, b'\r'), (0.5, b'scan'), (1.0, b'\x04')], s; \
		print('drive.py: script grammar ok')"

lint: ## bash -n every script; SKILL.md asset references must resolve
	@for f in record.sh record-demo.sh record-example.sh; do \
		bash -n $$f || exit 1; done; echo "shell: syntax ok"
	@if command -v shellcheck >/dev/null; then \
		shellcheck -S warning record.sh record-demo.sh record-example.sh \
		&& echo "shellcheck: ok"; \
	else echo "shellcheck: not installed, skipped"; fi
	@for f in $$(grep -oE 'assets/[a-z._-]+' SKILL.md | sort -u); do \
		test -f "$$f" || { echo "SKILL.md references missing file: $$f"; exit 1; }; \
	done; echo "SKILL.md asset references: resolve"

doctor: ## Print record.sh's resolved config for DIR (works without asciinema/agg)
	@./record.sh --print-config "$(DIR)"

demo: ## Record DIR with CMD preloaded (interactive): make demo DIR=~/git/proj CMD='make demo'
	@./record.sh "$(DIR)" $(CMD)

example: ## Record a leather example: make example NN=09-live
	@./record-example.sh "$(NN)"

chmod: ## Ensure scripts are executable
	@chmod +x record.sh record-demo.sh record-example.sh assets/drive.py

clean: ## Remove caches
	@rm -rf __pycache__ assets/__pycache__
