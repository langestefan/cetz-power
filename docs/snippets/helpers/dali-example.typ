#import "/src/lib.typ": *
#set page(margin: 8pt, width: auto, height: auto)
#set text(size: 7pt)

// A 400/230 V busbar section: a generator on the left, two DALI metering
// units (I and U captioned above their taps), and a load on the right.
#diagram(length: 1cm, {
  let y = 0
  let xl = 1.4 // left busbar
  let xr = 10.0 // right busbar
  let cr = 0.13 // CT clamp radius (so the U caption lines up with I)

  // Generator → left bus → line → right bus.
  machine("g", (0, y), "G")
  bus("bl", (xl, y - 1.0), (xl, y + 1.0))
  bus("br", (xr, y - 1.0), (xr, y + 1.0))
  wire("g.east", "bl.mid")
  wire((xl, y), (xr, y))

  // Caption a unit's two taps above the line: I over the clamp, U over the
  // V tap (= unit centre + width/2), both lifted by `cr` so they align.
  let caps(name, px, w, il, ul) = {
    note(name + "-ct.north", il, side: "north")
    note((px + w / 2, cr), ul, side: "north")
  }

  // Unit 1 — plain.
  dali("m1", (3.3, y), width: 1.0, lead: 0.35, tail: 0.45, clamp-radius: cr)
  caps("m1", 3.3, 1.0, [$I_1$], [$U_1$])

  // Unit 2 — blue VT, tinted box, relabelled.
  dali(
    "m2",
    (6.8, y),
    width: 1.0,
    lead: 0.3,
    tail: 0.5,
    clamp-radius: cr,
    tx-stroke: blue,
    label: [Meter],
    fill: blue.lighten(92%),
  )
  caps("m2", 6.8, 1.0, [$I_2$], [$U_2$])

  // A load near the right bus.
  load("ld", (8.9, y), lead: 0.3, size: 0.32)
})
