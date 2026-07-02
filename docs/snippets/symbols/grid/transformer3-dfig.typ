#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 7pt)

#diagram(length: 1.2cm, {
  // Grid bus feeds the HV winding.
  bus("b", (0, 0), length: 1.4, angle: 90deg)
  transformer3("t", (2.2, 0), label: (
    content: [23 / 0,96 / 0,69 kV],
    anchor: "south",
  ))
  wire("b.mid", "t.hv")

  // LV winding → stator path → generator.
  wire("t.lv", (rel: (1.6, 0), to: "t.lv"))
  machine("g", (rel: (1.95, 0), to: "t.lv"), "G")
  note("g.north", [stator], side: "north")

  // TV winding → rotor path → converter (here just a stub).
  wire("t.tv", (rel: (1.6, 0), to: "t.tv"))
  note((rel: (1.6, 0), to: "t.tv"), [rotor], side: "south")
})
