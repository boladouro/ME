#let project(title:"",authors:(), doc) ={
  set heading(
    bookmarked: true
  )
  set text(
    font: "Times New Roman",
    size: 12pt,
    hyphenate: false,
    spacing: 3pt
  )

  set page(
    numbering: "1 / 1"
    //margin: (left: 25mm, right: 25mm, top: 30mm, bottom: 30mm)
  )
  set par(
    justify: true,
    leading: 10.95pt, // calculo manual
  )
  doc
}