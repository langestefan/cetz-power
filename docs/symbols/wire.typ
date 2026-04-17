#import "/src/lib.typ" as pg

== Wires

Lines that connect symbols. Wires are not full "symbols" — they have no
label and no style family of their own; their stroke follows the global
`powergretz.wire.stroke`.

=== `wire(a, b)`

Straight line between two coordinates or anchors. A common use is to drop
a tap from a bus to a symbol below it:

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), length: 4, taps: 3)
  wire("b.tap2", (0, -1.2))
  load("ld", (0, -1.2))
})

```typst
wire("b.tap2", (0, -1.2))
load("ld", (0, -1.2))
```

=== `elbow(a, b, corner: "h")`

L-shaped routing. `corner: "h"` goes horizontally first then vertically;
`corner: "v"` does the opposite.

#pg.diagram(length: 1.2cm, {
  import pg: *
  bus("b", (0, 0), (4, 0), taps: 5)
  elbow("b.tap2", (0.5, -1.5), corner: "v")
  elbow("b.tap4", (4, -1.5), corner: "h")
})

```typst
elbow("b.tap2", (0.5, -1.5), corner: "v")
elbow("b.tap4", (4, -1.5), corner: "h")
```

=== Stroke override

Both accept an optional `stroke:` argument to override the family default:

```typst
wire(a, b, stroke: 2pt + red)
```
