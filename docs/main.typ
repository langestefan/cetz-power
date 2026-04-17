// powergretz documentation — main index.
//
// Compile this file (with its siblings) into a single flowing PDF. Each
// `docs/symbols/<family>.typ` and `docs/recipes/<name>.typ` is intended
// to stand on its own but is also included here as sections.

#import "/src/lib.typ" as pg

#set document(title: "powergretz — power-system diagrams in Typst")
#set page(paper: "a4", margin: (x: 2.2cm, y: 2cm), numbering: "1")
#set text(font: "Libertinus Serif", size: 10pt)
#set heading(numbering: none)
#set par(justify: true, leading: 0.7em)

#show heading.where(level: 1): set text(size: 22pt, weight: 700)
#show heading.where(level: 1): it => block(above: 1.2em, below: 0.6em, it)
#show heading.where(level: 2): set text(size: 14pt, weight: 600)
#show heading.where(level: 2): it => block(above: 1em, below: 0.4em, it)
#show heading.where(level: 3): set text(size: 11pt, weight: 600)
#show heading.where(level: 3): it => block(above: 0.8em, below: 0.3em, it)
#show raw.where(block: true): it => block(
  fill: luma(245), inset: 10pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8.5pt, it),
)

// Cover page
#align(center + horizon)[
  #text(size: 36pt, weight: 800)[powergretz]
  #v(0.5em)
  #text(size: 14pt)[Power-system single-line diagrams in Typst]
  #v(1em)
  #text(size: 11pt, fill: gray.darken(20%))[
    Version 0.1.0 · thin wrapper around CeTZ
  ]
]

#pagebreak()

// Outline — the heading is not itself outlined, so it doesn't self-reference.
#[
  #show heading.where(level: 1): set heading(outlined: false)
  = Contents
  #outline(indent: auto, depth: 2, title: none)
]

#pagebreak()
#include "getting-started.typ"

#pagebreak()
= Symbol reference

Each symbol family has its own section. Every section shows an example,
the parameters that matter most, the variants, and the anchors the
symbol exposes.

#include "symbols/bus.typ"
#include "symbols/wire.typ"
#include "symbols/grid.typ"
#include "symbols/transformer.typ"
#include "symbols/load.typ"
#include "symbols/pv.typ"

#pagebreak()
= Recipes

End-to-end examples that combine several symbol families.

#include "recipes/radial-feeder.typ"
#include "recipes/simple-sld.typ"
