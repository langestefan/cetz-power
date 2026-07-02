#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 8.25: Model van een vast toerental wind turbine met een
// asynchrone generator + Q-compensatie.
#diagram(length: 1.2cm, {
  // A labelled vertical bus with the two power-flow callouts that sit
  // under its bottom corners (P/Q in on the left, P/Q out on the right).
  let flow-bus(name, pos, title, left, right) = {
    bus(name, pos, length: 1.2, angle: 90deg, label: (
      content: align(center)[#title],
    ))
    note(
      name + ".south-west",
      left,
      side: "south-west",
      distance: 0.10,
      text-align: center,
    )
    note(
      name + ".south-east",
      right,
      side: "south-east",
      distance: 0.10,
      text-align: center,
    )
  }

  machine("M1", (0, 0), "V")

  // Externe net 1
  flow-bus(
    "b1",
    (1.5, 0),
    [Externe net \ 22,000 kV],
    [2,707 MW \ -0,069 MVAr],
    [-2,707 MW \ -0,069 MVAr],
  )
  wire("M1.east", "b1.mid")

  // Externe net 2
  flow-bus(
    "b2",
    (4.0, 0),
    [Externe net \ 22,040 kV],
    [2,712 MW \ 0,039 MVAr],
    [-2,712 MW \ -0,039 MVAr],
  )

  // 23 / 0,96 kV transformer between externe-net 2 and the mastvoet bus.
  transformer(
    "t1",
    "b2.mid",
    (rel: (3.5, 0), to: "b2.mid"),
    radius: 0.3,
    label: [23 / 0,96 kV],
  )
  wire("b1.mid", "b2.mid")

  // Mastvoet — taller bus, base aligned with the others, top extends up.
  bus("b3", (7.5, 0.4), length: 2.0, angle: 90deg, label: (
    content: align(center)[Mastvoet \ 0,928 kV],
    anchor: "north",
    distance: 0.15,
  ))
  note(
    (rel: (0, -0.4), to: "b3.south-west"),
    [2,735 MW \ 0,226 MVAr],
    side: "south-west",
    distance: 0.10,
    text-align: center,
  )

  // Q-compensatie: shunt capacitor to the right of mastvoet
  let cap-tap = bus-frac("b3", 5 / 6)
  capacitor(
    "c1",
    (rel: (1.25, 0), to: cap-tap),
    angle: -90deg,
    lead-out: 0,
    label: (
      content: align(center)[Q-compensatie \ 0,000 MW \ 1,402 MVAr],
    ),
  )
  wire(cap-tap, "c1.in")
  note(
    (rel: (0, -0.3), to: "c1.center"),
    [Qnom = 1,5 MVAr],
    side: "south",
    distance: 0,
  )

  // Gondel — small bus aligned with the lower part of mastvoet.
  bus("b4", (10.5, -0.3), length: 0.6, angle: 90deg, label: (
    content: align(center)[Gondel \ 0,934 kV],
    anchor: "north",
    distance: 0.15,
  ))
  // Mastvoet (b3, length 2.0) is taller than Gondel (b4, length 0.6); the
  // bottom 30 % of b3 spans the same height as the full b4, so the three
  // cables stay horizontal.
  multi-wire("b3", "b4", count: 3, from: (0, 0.3), to: (0, 1))

  // Asynchrone generator on the far right (image labels it "A").
  machine("M2", (12.5, -0.3), "A", label: (
    content: align(center)[Asynchrone generator \ 2,760 MW \ -1,163 MVAr],
    anchor: "north",
    distance: 0.20,
  ))
  wire("b4.mid", "M2.west")
})
