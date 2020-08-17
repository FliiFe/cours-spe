.PHONY: clean all figures

PDFS := $(addprefix target/,$(patsubst %.tex,%.pdf,$(wildcard *.tex)))
figures := $(patsubst %.tex,%.pdf,$(wildcard src/figures/*.tex))
LATEXMK := latexmk -pdfxe -silent

all: $(PDFS)

src/figures/%.pdf: src/figures/%.tex
	cd src/figures/ && $(LATEXMK) $(<F) && latexmk -c $(<F)

target/cours.pdf: cours.tex src/*.tex $(figures)
	$(LATEXMK) $<
	cp build/$(@F) $@

$(PDFS): | target

target:
	echo $(PDFS2)
	mkdir target

clean:
	rm -rf target build
	cd src/figures && latexmk -C

figures: $(figures)

.SECONDEXPANSION:
PER := %
target/%.pdf: %.tex src/preamble.tex src/%.tex $$(patsubst $$(PER).tex,$$(PER).pdf,$$(wildcard src/figures/%-*.tex))
	$(LATEXMK) $<
	cp build/$(@F) $@

