#import "template.typ": *

#let titulo = "Método de Aceitação-Rejeição & Análise de Estimadores"
#let subtitulo = "Exercício realizado no âmbito da Unidade Curricular de Modelação Estocástica do 3º ano da Licenciatura em Ciência de Dados"
#let indice= false
// TODO change to grid
// let versao
// let data
// let autores para ter for loop
#set align(center)
#set page(
  margin: (x: 3cm, y: 2.5cm),
)
#set text(
  hyphenate: false
)
#set par(
  first-line-indent: 0pt,
  justify: false,
)
#par(leading: 0.15cm)[
  #show: smallcaps

  #text(13pt)[ISCTE-IUL] \
  #text(12.5pt)[Licenciatura em Ciência de Dados]
]
#v(0.1cm)
#line(length: 100%, stroke: 0.5pt)

#v(0.4cm)
#par(leading: 0.22cm)[
  #text(32pt)[#titulo]
  #linebreak()
  #v(0.1cm)
  #text(16pt)[#subtitulo)]
]
#v(0.4cm)
#line(length: 100%, stroke: 1pt)
#if indice {
  v(0.4cm)
} else {
  v(4cm)
}

#par(leading: 0.3cm)[
  #text(22pt)[André Plancha, 105289]\
  #link("mailto:Andre_Plancha@iscte-iul.pt")[Andre_Plancha\@iscte-iul.pt]\
  #v(0.2cm)
  #text(22pt)[João Francisco Botas, 104782]\
  #link("mailto:Joao_Botas@iscte-iul.pt")
]
#if indice {
  v(3cm)
} else {
  v(6.5cm)
}
#par(leading: 0.3cm)[
  #text(16pt)[10 de outubro 2023]\
  #text(16pt)[Versão 1.0.1]
]
#v(3cm)
#set align(left)
// #outline(
//   title: text(weight: 600)[Índice],
//   fill: text(15pt, spacing: 220%)[#repeat(" . ")]
// )