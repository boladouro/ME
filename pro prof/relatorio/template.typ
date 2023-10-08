// #import "@preview/algo:0.3.3": algo, i, d, comment, code
#let project(fontsize:12pt, doc) ={
  let calculated_leading = 10.95pt
  set heading(
    bookmarked: true
  )
  set text(
    font: "Times New Roman",
    size: fontsize,
    hyphenate: false,
    lang: "pt",
    region: "pt"
  )
  set page(
    numbering: "1 / 1",
    margin: (left: 12mm, right: 12mm, top: 13mm, bottom: 13mm)
  )
  set par(
    justify: true,
    leading: calculated_leading, // calculo manual
    first-line-indent: 1cm,
  )
  show par: set block(spacing: calculated_leading)
  set math.equation(
    numbering: "(1)"
  )
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      numbering(
        el.numbering,
        ..counter(eq).at(el.location())
      )
    } else {
      it
    }
  }
  show figure.where(
    kind: table
  ): set figure.caption(position: top)

  show figure.caption: set text(size: fontsize - 2pt)
  // set algo() // not an element func yet (cause it's not possible on 0.8)
  show figure.where(
    kind: grid
  ): set figure(kind: image) // n funciona n sei pq
  
  set figure(placement: auto)
  doc
}
