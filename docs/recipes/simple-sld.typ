#import "/src/lib.typ" as pg

== Simple SLD — grid, transformer, bus, load

The most basic single-line diagram: external grid feeding a transformer
into a distribution bus, with a single load hanging off.

#pg.diagram(length: 1.2cm, {
  import pg: *

  external-grid("eg", (0, 0), label: [132 kV, 500 MVA])
  wire("eg.default", (0, -1.5))

  transformer("t", (0, -1.5), (0, -3), label: [132/11 kV])

  bus("lv", (-2, -3), (2, -3), taps: 3)

  load("l", "lv.tap2", label: [10 MW])
})

```typst
#pg.diagram(length: 1.2cm, {
  import pg: *

  external-grid("eg", (0, 0), label: [132 kV, 500 MVA])
  wire("eg.default", (0, -1.5))

  transformer("t", (0, -1.5), (0, -3), label: [132/11 kV])

  bus("lv", (-2, -3), (2, -3), taps: 3)

  load("l", "lv.tap2", label: [10 MW])
})
```
