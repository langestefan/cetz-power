#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Basic feeder: three stations with transformer + load drops, currents
// on every segment, and the default dashed continuation.
#test({
  feeder("f", (0, 0),
    (
      (label: [N1 \ 10 kV], load: [10 A \ 230 V]),
      (label: [N2 \ 10 kV], load: [10 A \ 230 V]),
      (label: [N3 \ 10 kV], load: [10 A \ 230 V]),
    ),
    currents: ([56 A], [47 A], [38 A], [28 A]))
})

// Upward drops, a skipped first current, and no dashed continuation.
#test({
  feeder("f", (0, 0),
    (
      (label: [A], load: [5 A]),
      (label: [B], load: [5 A]),
    ),
    currents: (none, [20 A], [10 A]),
    up: true, extend: 0)
})

// Bare labelled taps (no drop) with custom lead / spacing / dot.
#test({
  feeder("f", (0, 0),
    (
      (label: [t1],),
      (label: [t2],),
      (label: [t3],),
    ),
    lead: 1, spacing: 1.5, dot: 0.08)
})

// Feeder hung off a bus anchor, mixing a bare tap with drops.
#test({
  bus("b", (0, 0), length: 1.2, angle: 90deg)
  feeder("f", "b.mid",
    (
      (label: [s1], load: [3 A]),
      (label: [s2],),
      (label: [s3], load: [3 A]),
    ),
    lead: 1, spacing: 1.5, currents: ([9 A], none, [6 A], [3 A]))
})

// `tx: false` — loads hang straight off the taps, no transformers.
#test({
  feeder("f", (0, 0),
    ((label: [L1], load: [6 A]), (label: [L2], load: [6 A])),
    tx: false, currents: ([12 A], [6 A], none))
})

// Per-station load styling (thin / thick / coloured) + per-station `tx`.
#test({
  feeder("f", (0, 0),
    (
      (label: [thin], load: [2 A], stroke: 0.4pt + black, fill: none),
      (label: [thick], load: [5 A], stroke: 1.5pt + black, tx: false),
      (label: [red], load: [3 A], stroke: red, fill: red),
    ),
    spacing: 2)
})

// Transformer styling: feeder-wide tx-fill + per-station tx-stroke / tx-fill.
#test({
  feeder("f", (0, 0),
    (
      (label: [A], load: [6 A], tx-stroke: red, stroke: red, fill: red),
      (label: [B], load: [6 A], tx-stroke: blue, tx-fill: blue.lighten(70%)),
    ),
    tx-fill: yellow.lighten(60%), spacing: 2.4)
})

// Run-line styling: a heavier coloured busbar with a matching dashed tail.
#test({
  feeder("f", (0, 0),
    ((label: [N1], load: [6 A]), (label: [N2], load: [6 A])),
    currents: ([12 A], [6 A], none),
    line-stroke: 1.6pt + blue,
    extend-stroke: (paint: blue, thickness: 1.6pt, dash: "dashed"))
})

// Angle of attack: positive, negative, and steep (current labels follow).
#test({
  let sts = ((label: [A], load: [4 A]), (label: [B], load: [4 A]))
  feeder("p", (0, 0), sts, angle: 25deg, lead: 1, spacing: 1.6, currents: ([8 A], [4 A], none))
  feeder("n", (0, 0), sts, angle: -25deg, lead: 1, spacing: 1.6)
  feeder("v", (4, 0), sts, angle: 70deg, lead: 1, spacing: 1.6, up: true)
})

// drop-angle: tilted run with vertical drops, and raked drops on a flat run.
#test({
  let sts = ((label: [A], load: [4 A]), (label: [B], load: [4 A]))
  feeder("t", (0, 0), sts, angle: 20deg, drop-angle: -90deg, lead: 1, spacing: 1.6,
    currents: ([8 A], [4 A], none))
  feeder("r", (0, -2.6), sts, drop-angle: -55deg, lead: 1, spacing: 1.6)
})
