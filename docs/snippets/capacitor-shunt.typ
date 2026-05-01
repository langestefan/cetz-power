#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Single-pole shunt cap connecting to a bus. `lead-out: 0` drops the
  // upper lead (and the `out` anchor) — the single-line / one-line
  // diagram convention for a shunt element with no return-to-ground
  // wire drawn.
  bus("b", (0, 0), length: 1.6, taps: 3)
  // Cap placed above the middle tap so the connecting wire is vertical.
  capacitor("c1", "b.tap2", lead-out: 0)
})
