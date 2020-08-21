MAIN_FN := cours

.PHONY: clean all figures help main newchapter init

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
MAIN_TARGET := target/$(MAIN_FN).pdf

help: ## Print available targets
	@echo "${PURPLE}:: ${BOLD}${GREEN}$$(basename $$(realpath .))${RESET} ${PURPLE}::${RESET}"
	@echo ""
	@echo "Example:"
	@echo "  | make all -j8  ${YELLOW}# Build everything using 8 threads${RESET}"
	@echo "  | make main  ${YELLOW}# Build the main target ${RESET}"
	@echo "  | make $(MAIN_TARGET)  ${YELLOW}# Same as: make main ${RESET}"
	@echo ""
	@echo "$(YELLOW)List of PHONY targets:$(RESET)"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${GREEN}${BOLD}%-22s${RESET} %s\n", $$1, $$2}'
	@echo "$(YELLOW)Main target:$(RESET)"
	@echo " " $(MAIN_TARGET)
	@if ! [[ -z "$(FIGURES)" ]]; then echo "$(YELLOW)List of figures:$(RESET)"; fi
	@for f in $(FIGURES); do \
		echo " " $${f}; \
	done
	@if [[ "$(PDFS)" != "$(MAIN_TARGET)" ]] && ! [[ -z "$(PDFS)" ]]; then \
		echo "$(YELLOW)List of chapters:$(RESET)"; fi
	@for f in $(PDFS); do \
		if ! [[ $$f =~ .*$(MAIN_FN).* ]]; then \
			echo " " $$f; \
		fi; \
	done

newchapter: ## Make a new chapter
	@echo -ne "${GREEN}Chapter filename (no extension):${RESET} "; \
	read fn; \
	echo -ne "${GREEN}Chapter name:${RESET} "; \
	read cn; \
	if [[ "$$fn" =~ ^[a-zA-Z0-9-]+$$ ]]; then \
		if ! [[ -z "$$cn" ]]; then \
			cat .latex_templates/chapter-base.tex | sed s/FN/$$fn/g >$$fn.tex; \
			cat .latex_templates/chapter-src.tex | sed "s/CN/$$cn/g" >src/$$fn.tex; \
			echo \\input{src/$$fn.tex} >> src/chapterlist.tex; \
		else \
			echo "Chapter name empty"; \
			exit 1; \
		fi \
	else \
		echo "Filename does not match ^[a-zA-Z0-9-]+$$"; \
		exit 1; \
	fi;

main: $(MAIN_TARGET) ## Build the main target

changemainfilename: ## Change the main document's base name
	@echo -ne "${GREEN}New filename:${RESET} "; \
		read nfn; \
		mv $(MAIN_FN).tex $$nfn.tex; \
		sed -i "s/^MAIN_FN.*:=.*\$$/MAIN_FN := $$nfn/" Makefile

all: $(PDFS) $(MAIN_TARGET) ## Build everything

src/figures/%.pdf: src/figures/%.tex
	@echo "$(GREEN)Compiling figure $(YELLOW)$(<F)$(GREEN) into $(YELLOW)$@$(RESET)"
	cd src/figures/ && $(LATEXMK) $(<F) && latexmk -silent -c $(<F)

$(MAIN_TARGET): $(MAIN_FN).tex src/*.tex $(FIGURES)
	@echo "$(GREEN)Compiling main document $(YELLOW)$(<F)$(GREEN) into $(YELLOW)$@$(RESET)"
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

