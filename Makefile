.PHONY: clean all figures help main

BLACK        := $(shell tput -Txterm setaf 0)
RED          := $(shell tput -Txterm setaf 1)
GREEN        := $(shell tput -Txterm setaf 2)
YELLOW       := $(shell tput -Txterm setaf 3)
LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
PURPLE       := $(shell tput -Txterm setaf 5)
BLUE         := $(shell tput -Txterm setaf 6)
WHITE        := $(shell tput -Txterm setaf 7)
BOLD         := $(shell tput bold)
RESET        := $(shell tput -Txterm sgr0)

PDFS := $(addprefix target/,$(patsubst %.tex,%.pdf,$(wildcard *.tex)))
FIGURES := $(patsubst %.tex,%.pdf,$(wildcard src/figures/*.tex))
LATEXMK := latexmk -pdfxe -silent # -use-make
MAIN_TARGET := target/cours.pdf

help: ## Print available targets
	@echo "${PURPLE}:: ${BOLD}${GREEN}$$(basename $$(realpath .))${RESET} ${PURPLE}::${RESET}"
	@echo ""
	@echo "Example:"
	@echo "  | make all -j8             ${YELLOW}# Build everything using 8 threads${RESET}"
	@echo "  | make main                ${YELLOW}# Build the main target ${RESET}"
	@echo "  | make $(MAIN_TARGET)    ${YELLOW}# Same as: make main ${RESET}"
	@echo ""
	@echo "$(YELLOW)List of PHONY targets:$(RESET)"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${GREEN}${BOLD}%-10s${RESET} %s\n", $$1, $$2}'
	@echo "$(YELLOW)Main target:$(RESET)"
	@echo " " $(MAIN_TARGET)
	@echo "$(YELLOW)List of figures:$(RESET)"
	@for f in $(FIGURES); do \
		echo " " $${f}; \
	done
	@echo "$(YELLOW)List of chapters:$(RESET)"
	@for f in $(PDFS); do \
		if ! [[ $$f =~ .*cours.* ]]; then \
			echo " " $$f; \
		fi; \
	done

main: $(MAIN_TARGET) ## Build the main target

all: $(PDFS) ## Build everything

src/figures/%.pdf: src/figures/%.tex
	@echo "$(GREEN)Compiling $(YELLOW)$(<F)$(GREEN) into $(YELLOW)$@$(RESET)"
	cd src/figures/ && $(LATEXMK) $(<F) && latexmk -silent -c $(<F)

$(MAIN_TARGET): cours.tex src/*.tex $(FIGURES)
	$(LATEXMK) $<
	cp build/$(@F) $@

$(PDFS): | target

target:
	mkdir target

clean: ## Delete compiled documents and latex-generated files
	rm -rf target build
	cd src/figures && latexmk -C

figures: $(FIGURES) ## Build every figure in src/figures/

.SECONDEXPANSION:
PER := %
target/%.pdf: %.tex src/preamble.tex src/%.tex $$(patsubst $$(PER).tex,$$(PER).pdf,$$(wildcard src/figures/%-*.tex))
	@echo "$(GREEN)Compiling $(YELLOW)$(<)$(GREEN) into $(YELLOW)$@$(RESET)"
	$(LATEXMK) $<
	cp build/$(@F) $@

