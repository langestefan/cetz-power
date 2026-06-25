#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 10.15: MS-net met een equivalente verbinding voor 200 km kabel.
// MV network with a 200 km cable modelled as an equivalent loop:
// the upper "Equivalent van 200 km" path tapping K2 (then terminating
// at the floating Koo bus) and the lower "Kabel" path together model
// the cable's pi-equivalent. K3 carries the load downstream.
#diagram(length: 1.2cm, {
  // Red = source side (V → K1 → primary winding of the transformer).
  let r = rgb("#cc1122")

  // ── Define every bus and machine first so anchors exist before
  //    any wire references them. ──

  machine("V", (0, 0), "V", stroke: 1pt + r, label: (
    content: [Netvoeding], anchor: "south", distance: 0.18,
  ))
  bus("K1", (1.5, 0), length: 0.7, angle: 90deg,
    stroke: 1.8pt + r,
    label: (content: [K1], anchor: "north", distance: 0.2),
  )
  bus("K2", (3.7, 0), length: 1.5, angle: 90deg, label: (
    content: [K2], anchor: "north", distance: 0.2,
  ))
  // Koo — vertical bus, floating off K2's upper-cable tap. Does NOT
  // connect to K3.
  bus("Koo", (5.85, 1.85), length: 0.5, angle: 90deg, label: (
    content: [Koo], anchor: "north", distance: 0.2,
  ))
  bus("K3", (5.85, 0), length: 1.5, angle: 90deg, taps: 7, label: (
    content: [K3], anchor: "north", distance: 0.2,
  ))

  // Right-side branches (Motor / load / Generator) placed further
  // out so labels fit between K3 and each symbol without crossing
  // the bus.
  machine("M1", (rel: (2.5, 0), to: "K3.tap6"), "M")
  load("L1", (rel: (2.5, 0), to: "K3.tap4"), angle: 90deg)
  machine("G1", (rel: (2.5, 0), to: "K3.tap2"), "G")

  // ── Source-side wiring (red). ──
  wire("V.east", "K1.mid", stroke: 1pt + r)

  // ── Transformer: now using the symbol with per-winding stroke
  //    overrides. `primary-stroke` colours the LEFT (in-side) circle
  //    + its lead red; `secondary-stroke` keeps the RIGHT one black.
  //    No more hand-drawn primitives. ──
  transformer("T1", "K1.mid", "K2.mid",
    radius: 0.22, distance: 0.35,
    primary-stroke: 1pt + r,
    secondary-stroke: 0.8pt + black,
    label: (
      content: [Transformator],
      anchor: "south", distance: 0.18,
    ),
  )

  // ── Equivalent-cable upper path: K2 → Koo (terminates at Koo,
  //    no continuation to K3). Z-step polyline:
  //      1. horizontal exit from K2's side (at K2.mid)
  //      2. vertical rise
  //      3. horizontal entry into Koo's side (at Koo.mid)
  //    so both ends branch perpendicularly off their respective
  //    vertical buses, the same way Kabel taps K2 and K3 from
  //    the side. ──
  wire(
    (3.7, 0),         // K2.mid — horizontal tap on K2's side
    (4.7, 0),         // exit corner (still at K2's y)
    (4.7, 1.85),      // rise corner (now at Koo's y)
    "Koo.mid",        // horizontal entry into Koo's side at its mid
  )

  cetz.draw.content(
    (2.5, 1.50),
    anchor: "south-west",
    [Equivalent van 200 km],
  )

  // ── Lower path: the cable itself. The wire's own `label:` arg
  //    drops the "Kabel" caption at the midpoint, below the line.
  wire(bus-frac("K2", 2 / 8), bus-frac("K3", 2 / 8),
    label: [Kabel], label-side: "south", label-distance: 0.2,
  )

  // ── Right-side branch wires off K3, each carrying its own label
  //    above the wire — `wire(..., label: …)` does the positioning. ──
  wire("K3.tap6", "M1.west", label: [Motor], label-align: "center")
  wire("K3.tap4", "L1.in",   label: [Belasting], label-align: "center")
  wire("K3.tap2", "G1.west", label: [Generator], label-align: "center")
})
