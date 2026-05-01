#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 8.25: Model van een vast toerental wind turbine met een
// asynchrone generator + Q-compensatie.
#diagram(length: 1.2cm, {
  machine("M1", (0, 0), "V")

  // Externe net 1
  bus("b1", (1.5, 0), length: 1.2, angle: 90deg, label: (
    content: align(center)[Externe net \ 22,000 kV],
  ))
  cetz.draw.content("b1.south-west", anchor: "north-east", padding: 0.10,
    align(center)[2,707 MW \ -0,069 MVAr])
  cetz.draw.content("b1.south-east", anchor: "north-west", padding: 0.10,
    align(center)[-2,707 MW \ -0,069 MVAr])

  wire("M1.east", "b1.mid")

  // Externe net 2
  bus("b2", (4.0, 0), length: 1.2, angle: 90deg, label: (
    content: align(center)[Externe net \ 22,040 kV],
  ))
  cetz.draw.content("b2.south-west", anchor: "north-east", padding: 0.10,
    align(center)[2,712 MW \ 0,039 MVAr])
  cetz.draw.content("b2.south-east", anchor: "north-west", padding: 0.10,
    align(center)[-2,712 MW \ -0,039 MVAr])

  // 23 / 0,96 kV transformer between externe-net 2 and the mastvoet bus.
  transformer("t1", "b2.mid", (rel: (3.5, 0), to: "b2.mid"),
    radius: 0.3, label: [23 / 0,96 kV])
  wire("b1.mid", "b2.mid")

  // Mastvoet — taller bus, base aligned with the others, top extends up.
  bus("b3", (7.5, 0.4), length: 2.0, angle: 90deg, label: (
    content: align(center)[Mastvoet \ 0,928 kV],
    anchor: "north",
    distance: 0.15,
  ))
  cetz.draw.content((rel: (0, -0.4), to: "b3.south-west"),
    anchor: "north-east", padding: 0.10,
    align(center)[2,735 MW \ 0,226 MVAr])

  // Q-compensatie: shunt capacitor to the right of mastvoet, rotated
  // -90deg so the plates run vertical (parallel to the mastvoet bus).
  // Cap position is computed *relative to* the bus tap so it sits at
  // exactly the tap's y, regardless of how mastvoet itself is placed —
  // makes the connecting wire purely horizontal. Tap point is 1/8 from
  // the top of mastvoet (bus-frac 7/8). No lead-out — single-line
  // convention, no return-to-ground wire.
  let cap-tap = bus-frac("b3", 20/12)
  capacitor("c1", (rel: (1.25, 0), to: cap-tap),
    angle: -90deg,
    lead-out: 0,
    label: (
      content: align(center)[Q-compensatie \ 0,000 MW \ 1,402 MVAr],
    ),
  )
  wire(cap-tap, "c1.in")
  cetz.draw.content(
    (rel: (0, -0.3), to: "c1.center"),
    anchor: "north",
    align(center)[Qnom = 1,5 MVAr],
  )

  // Gondel — small bus aligned with the lower part of mastvoet.
  bus("b4", (10.5, -0.3), length: 0.6, angle: 90deg, label: (
    content: align(center)[Gondel \ 0,934 kV],
    anchor: "north",
    distance: 0.15,
  ))
  multi-wire("b3", "b4", count: 3, from: (0, 0.6), to: (0, 0.6))

  // Asynchrone generator on the far right (image labels it "A").
  machine("M2", (12.5, -0.3), "A", label: (
    content: align(center)[Asynchrone generator \ 2,760 MW \ -1,163 MVAr],
    anchor: "north",
    distance: 0.20,
  ))
  wire("b4.mid", "M2.west")
})
