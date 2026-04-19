#import "/src/lib.typ" as pg
#import "@preview/cetz:0.4.2"
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 8.25: Model van een vast toerental wind turbine met een asynchrone generator
#pg.diagram(length: 1.2cm, {
  import pg: *

  machine("M1", (0, 0), "V")

  // Add the first bus
  bus("b1", (1.5, 0), length: 1.2, angle: 90deg, label: (content: align(center)[External grid \ 22 kV]))

  cetz.draw.content("b1.south-west", anchor: "north-east", padding: 0.10, align(center)[2,707 MW \ -0,069 MVAr])
  cetz.draw.content("b1.south-east", anchor: "north-west", padding: 0.10, align(center)[-2,707 MW \ -0,069 MVAr])

  wire("M1.east", "b1.mid")

  // Add a second bus
  bus("b2", (4.0, 0), length: 1.2, angle: 90deg, label: (content: align(center)[External grid \ 22 kV]))
  cetz.draw.content("b2.south-west", anchor: "north-east", padding: 0.10, align(center)[2,712 MW \ 0,039 MVAr])
  cetz.draw.content("b2.south-east", anchor: "north-west", padding: 0.10, align(center)[-2,712 MW \ -0,039 MVAr])

  // Transformer between bus 1 and bus 2
  transformer("t1", "b2.mid", (rel: (3.5, 0), to: "b2.mid"), radius: 0.3, label: [23 / 0,96 kV])
  wire("b1.mid", "b2.mid")

  // Add a third, taller bus that aligns with the others at the bottom but extends higher up
  bus("b3", (7.5, 0.4), length: 2.0, angle: 90deg, label: (
    content: align(center)[Mastvoet \ 22 kV],
    anchor: "north",
    distance: 0.15,
  ))
  cetz.draw.content((rel: (0, -0.4), to: "b3.south-west"), anchor: "north-east", padding: 0.10, align(
    center,
  )[2,735 MW \ 0,226 MVAr])
})
