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
#set text(size: 7pt)

#diagram({
  let hv-y = 0
  let lv-y = -2.4

  // ── HV side ─────────────────────────────────────────────────────
  external-grid("grid", (0, 1.0), label: [132 kV, 500 MVA])
  wire("grid.in", (0, hv-y))

  // Two parallel 132/11 kV transformers, each behind its own breaker.
  // Drawn before the buses so the bars cover the lead roots.
  for (i, x) in (-1.5, 1.5).enumerate() {
    let n = str(i + 1)
    wire((x, hv-y), (x, hv-y - 0.15))
    breaker("hcb" + n, (x, hv-y - 0.15), (x, hv-y - 0.65))
    wire((x, hv-y - 0.65), (x, hv-y - 0.8))
    transformer(
      "t" + n,
      (x, hv-y - 0.8),
      (x, lv-y + 0.4),
      radius: 0.3,
      vector: ("delta", "wye"),
      label: [T#n \ 132/11 kV \ 50 MVA],
    )
    wire((x, lv-y + 0.4), (x, lv-y))
  }

  // ── Three outgoing feeders: disconnector + breaker + CT + load ──
  for (i, x) in (-3, -1, 1).enumerate() {
    let n = str(i + 1)
    wire((x, lv-y), (x, lv-y - 0.15))
    switch("d" + n, (x, lv-y - 0.15), (x, lv-y - 0.65), closed: true)
    breaker("cb" + n, (x, lv-y - 0.65), (x, lv-y - 1.25))
    wire((x, lv-y - 1.25), (x, lv-y - 1.9))
    ct("ct" + n, (x, lv-y - 1.55))
    load("l" + n, (x, lv-y - 1.9), label: [#((i + 1) * 8) MW])
  }

  // ── Solar PV backfeed on the LV bus ─────────────────────────────
  pv-panel("pv", (3, lv-y), label: [PV 5 MW])

  // ── Buses ───────────────────────────────────────────────────────
  bus("hv", (-2.4, hv-y), (2.4, hv-y), label: (
    content: [132 kV],
    anchor: "west",
  ))
  bus("lv", (-4.4, lv-y), (4.4, lv-y), label: (
    content: [11 kV],
    anchor: "west",
  ))
})
