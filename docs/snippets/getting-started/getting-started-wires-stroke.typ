#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Wires read only `cetz-power.wire.stroke` — restyle every wire in
  // one place. Symbol bodies keep their own stroke.
  cetz.draw.set-style(cetz-power: (wire: (stroke: 1.4pt + orange)))

  bus("b1", (0, 0), length: 1.4, angle: 90deg)
  bus("b2", (3, 0), length: 1.4, angle: 90deg)
  wire("b1.mid", "b2.mid")
  elbow("b1.end", "b2.end", corner: "h")
})
