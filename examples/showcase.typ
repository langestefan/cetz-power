// A realistic small-substation SLD: 132 kV external grid feeding two
// 132/11 kV transformers onto an 11 kV distribution bus, with three
// outgoing feeders (each with a disconnector + breaker + CT) and a
// small PV plant backfeeding the LV bus.
//
// Compile this with:
//
//     typst compile examples/showcase.typ showcase.pdf --root .
//
// Or with the node wrapper used during development:
//
//     node tsc.js examples/showcase.typ showcase.pdf --workspace=.

#import "/src/lib.typ": *

#set page(margin: 14pt, width: auto, height: auto)

#diagram({
  // ── HV side ─────────────────────────────────────────────────────
  external-grid("grid", (0, 0), label: [132 kV, 500 MVA])
  wire("grid.default", (0, -1.2))

  // HV bus
  bus("hv", (-4, -1.2), (4, -1.2), taps: 7)
  cetz.draw.content((-4.3, -1.2), "1", anchor: "east")

  // Two parallel 132/11 kV transformers on taps 2 and 6
  transformer("t1", "hv.tap2", (-2.5, -3), label: [132/11 kV \ 50 MVA])
  transformer("t2", "hv.tap6", ( 2.5, -3), label: [132/11 kV \ 50 MVA])

  // LV bus at 11 kV
  bus("lv", (-5, -3), (5, -3), taps: 9)
  cetz.draw.content((-5.3, -3), "2", anchor: "east")

  // ── Three outgoing feeders ─────────────────────────────────────
  for (i, xs) in ((0, -3.5), (1, 0), (2, 3.5)).enumerate() {
    let (idx, x) = xs
    // Disconnector + CB + CT stack
    let tap = "tap" + str(2 + idx * 3)
    disconnector("d" + str(idx), "lv." + tap, (x, -4.2))
    circuit-breaker("cb" + str(idx), (x, -4.2), (x, -5.2))
    current-transformer("ct" + str(idx), (x, -5.2), (x, -5.8))
    load("l" + str(idx), (x, -5.8), label: [#((idx + 1) * 8) MW])
  }

  // ── Solar PV backfeed on an LV bus tap ────────────────────────
  solar-plant("pv", (4.5, -4.3), cells: 4, label: [PV 5 MW])
  wire("lv.tap9", (4.5, -4.3))
})
