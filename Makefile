all: slides

slides: slides.tex
	xelatex slides.tex
	xelatex $< -o slides.pdf
	rm -f *.aux *.snm *.toc *.log *.nax *.out
	#evince slides.pdf

slides-bib: slides.tex
	pdflatex slides.tex
	biber slides
	pdflatex $< -o slides.pdf
	rm -f *.aux *.snm *.toc *.log *.naz *.out

clean:
	rm -f *.aux *.snm *.toc *.log *.nax *.out *.nav
