#let ifrac(num, denom) = { // emilylime on disc, adapted
  import math: *;
  set text(
    size: 18pt
  )
  move(dx: -2pt, dy: -1pt,
    attach("\u{2215}", // U+2215 ∕ Division Slash
      tl: move(script(num), dx: 2pt),
      br: move(script(denom), dx: -2pt, dy: -2pt),
    )
  )

}