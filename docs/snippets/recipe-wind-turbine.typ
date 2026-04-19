#import "/src/lib.typ" as pg
#import "@preview/cetz:0.4.2"
#set page(margin: 6pt, width: auto, height: auto)

// Figuur 8.25: Model van een vast toerental wind turbine met een asynchrone generator
#pg.diagram(length: 1.2cm, {
  import pg: *
  
  machine("M1", (0, 0), "V")
  bus("b1", (1.0, 0), length: 1.2, angle: 90deg,
    label: (content: align(center)[External grid \ 22 kV]))
  wire("M1.east", "b1.mid")
})
