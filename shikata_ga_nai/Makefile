SRC = slides.tex
PDF = slides.pdf
AUX = slides.aux
TEXC := xelatex
TEXC_OPTS += -shell-escape

.PHONY: clean install 

all: $(PDF) shellcode

shellcode:
	/opt/msf/msfvenom -p linux/x86/exec -e x86/shikata_ga_nai -i 12 CMD='cat /etc/passwd' R > execve.shellcode

$(AUX):
	$(TEXC) $(TEXC_OPTS) $(SRC)

$(PDF): beamerthemem.sty $(AUX) $(SRC)
	$(TEXC) $(TEXC_OPTS) $(SRC)

clean:
	@rm -f $(PDF)
	@git clean -xfd
