SHELL     := /bin/bash
ALLOW_DIR := allow

CLAUDE_OUTPUT  := settings.json
OPENCODE_OUTPUT := opencode.json

SOURCES := $(wildcard $(ALLOW_DIR)/*.jsonc)

.PHONY: all claude opencode clean help

## all: clean and regenerate all agent configs
all: clean claude opencode

## claude: merge all allow lists into settings.json
claude: $(CLAUDE_OUTPUT)

$(CLAUDE_OUTPUT): $(SOURCES)
	@echo "Merging $(words $(SOURCES)) allow files → $(CLAUDE_OUTPUT)"
	@for f in $(SOURCES); do \
		sed '/^[[:space:]]*\/\//d' "$$f"; \
	done \
	| jq -s 'map(.permissions.allow) | add | unique | {"permissions": {"allow": .}}' \
	> $(CLAUDE_OUTPUT)
	@echo "Done → $(CLAUDE_OUTPUT)"

## opencode: merge all allow lists into opencode.json
opencode: $(OPENCODE_OUTPUT)

$(OPENCODE_OUTPUT): $(SOURCES)
	@echo "Merging $(words $(SOURCES)) allow files → $(OPENCODE_OUTPUT)"
	@for f in $(SOURCES); do \
		sed '/^[[:space:]]*\/\//d' "$$f"; \
	done \
	| jq -s 'map(.permissions.allow) | add | unique | map(ltrimstr("Bash(") | rtrimstr(":*)") | {(. + "*"): "allow"}) | add | {"*": "ask"} + . | {"permission": {"bash": .}}' \
	> $(OPENCODE_OUTPUT)
	@echo "Done → $(OPENCODE_OUTPUT)"

## clean: remove all generated configs
clean:
	@rm -f $(CLAUDE_OUTPUT) $(OPENCODE_OUTPUT)
	@echo "Removed $(CLAUDE_OUTPUT) $(OPENCODE_OUTPUT)"

## help: show available targets
help:
	@grep -E '^##' Makefile | sed 's/## /  /'
