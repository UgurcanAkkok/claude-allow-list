SHELL     := /bin/bash
ALLOW_DIR := allow
OUTPUT    := settings.json

SOURCES := $(wildcard $(ALLOW_DIR)/*.jsonc)

.PHONY: build clean help

## build: merge all allow lists into a single settings.json
build: $(OUTPUT)

$(OUTPUT): $(SOURCES)
	@echo "Merging $(words $(SOURCES)) allow files → $(OUTPUT)"
	@for f in $(SOURCES); do \
		sed '/^[[:space:]]*\/\//d' "$$f"; \
	done \
	| jq -s 'map(.permissions.allow) | add | unique | {"permissions": {"allow": .}}' \
	> $(OUTPUT)
	@echo "Done → $(OUTPUT)"

## clean: remove generated settings.json
clean:
	@rm -f $(OUTPUT)
	@echo "Removed $(OUTPUT)"

## help: show available targets
help:
	@grep -E '^##' Makefile | sed 's/## /  /'
