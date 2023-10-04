# compila o rnw
build:
  R -e "if (!require('knitr')) install.packages('knitr')"
  R -e "if (!require('here')) install.packages('here')"
  R -e "knitr::knit(input = here::here('relatorio', 'main.Rnw'),output = here::here('relatorio', 'out', 'relatorio.tex'),)"
  tectonic relatorio/out/relatorio.tex

## tetonic ta v0.14.1
