IMAGE = texlive/texlive:latest
WORKDIR = /data
DOCKER = docker run --rm \
	-v $(PWD):$(WORKDIR) \
	-w $(WORKDIR) \
	$(IMAGE)

TARGETS = main anomy

.PHONY: all clean rebuild

all: $(TARGETS)

%:
	$(DOCKER) latexmk -xelatex -interaction=nonstopmode $@.tex
	$(DOCKER) latexmk -c

clean:
	$(DOCKER) latexmk -c

rebuild: clean all
