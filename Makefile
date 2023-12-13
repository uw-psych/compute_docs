SHELL := /bin/bash
.SHELLFLAGS := -e -O xpg_echo -o errtrace -o functrace -c
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKE := $(make)
DATETIME_FORMAT := %(%Y-%m-%d %H:%M:%S)T
.ONESHELL:
.SUFFIXES:
.DELETE_ON_ERROR:

# Targets for printing help:
.PHONY: help
help:  ## Prints this usage.
	@printf '== Recipes ==\n' && grep --no-filename -E '^[a-zA-Z0-9-]+:' $(MAKEFILE_LIST) && echo '\n== Images ==' && echo $(SUBDIRS) | tr ' ' '\n' 
# see https://www.gnu.org/software/make/manual/html_node/Origin-Function.html
MAKEFILE_ORIGINS := \
	default \
	environment \
	environment\ override \
	file \
	command\ line \
	override \
	automatic \
	\%

PRINTVARS_MAKEFILE_ORIGINS_TARGETS += \
	$(patsubst %,printvars/%,$(MAKEFILE_ORIGINS)) \

.PHONY: $(PRINTVARS_MAKEFILE_ORIGINS_TARGETS)
$(PRINTVARS_MAKEFILE_ORIGINS_TARGETS):
	@$(foreach V, $(sort $(.VARIABLES)), \
		$(if $(filter $(@:printvars/%=%), $(origin $V)), \
			$(info $V=$($V) ($(value $V)))))

.PHONY: printvars
printvars: printvars/file ## Print all Makefile variables (file origin).

.PHONY: printvar-%
printvar-%: ## Print one Makefile variable.
	@echo '($*)'
	@echo '  origin = $(origin $*)'
	@echo '  flavor = $(flavor $*)'
	@echo '   value = $(value  $*)'


.DEFAULT_GOAL := help

YQ := $(shell command -v yq 2> /dev/null)
ifeq ($(YQ),)
$(error "yq is not available")
endif

QUARTO := $(shell command -v quarto 2> /dev/null)
ifeq ($(QUARTO),)
$(error "quarto is not available")
endif

OUTPUT_DIR := $(shell $(YQ) '.project.output-dir // "_site"'  _quarto.yml)

.PHONY: clean
clean: ## Remove all generated files.
	rm -rfv $(OUTPUT_DIR)

.PHONY: build
build: ## Build the site.
	$(QUARTO) render

.PHONY: lint-glossary
lint-glossary: glossary.yml ## Lint the glossary.
	$(YQ) 'sort_keys(..) | .. style="literal"' $<
