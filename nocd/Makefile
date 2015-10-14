SRC = slides.tex
PDF = slides.pdf
AUX = slides.aux
TEXC := xelatex
TEXC_OPTS += -shell-escape

.PHONY: clean install slides

all: $(PDF) 

slides: $(PDF)

$(AUX):
	$(TEXC) $(TEXC_OPTS) $(SRC)

$(PDF): beamerthemem.sty $(AUX) $(SRC)
	$(TEXC) $(TEXC_OPTS) $(SRC)

clean:
	@rm -f $(PDF)
	@git clean -xfd

