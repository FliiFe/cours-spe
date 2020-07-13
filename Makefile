.PHONY: clean all figures

PDFS := target/cours.pdf target/calculdiff.pdf target/polynomes.pdf
figures := $(patsubst %.tex,%.pdf,$(wildcard src/figures/*.tex))

all: $(PDFS)

src/figures/%.pdf: src/figures/%.tex
	cd src/figures/ && latexmk -pdf $(<F) && latexmk -c $(<F)

target/cours.pdf: $(figures)

$(PDFS): | target

target:
	mkdir target

clean:
	rm -rf target build
	cd src/figures && latexmk -C

figures: $(figures)

.SECONDEXPANSION:
PER := %
target/%.pdf: %.tex $$(patsubst $$(PER).tex,$$(PER).pdf,$$(wildcard src/figures/%-*.tex))
	latexmk -pdf $<
	cp build/$(@F) $@

