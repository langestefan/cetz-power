#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Earthing switch: `earthing: true` draws the IEC earth-electrode
  // mark at the `out` end. Open (left) and closed / earthed (right).
  bus("b1", (0, 0), length: 1.4)
  switch("es1", "b1.mid", (0, -1.3), earthing: true)
  bus("b2", (2.4, 0), length: 1.4)
  switch("es2", "b2.mid", (2.4, -1.3), earthing: true, closed: true)
})
