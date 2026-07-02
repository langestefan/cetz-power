#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)
#set text(size: 8pt)

#diagram(length: 1.2cm, {
  let flex = rgb("#29abe2")
  bus("b1", (1.6, 0), length: 1.4, angle: 90deg, label: [1])
  bus("b2", (4.4, 0), length: 1.4, angle: 90deg, label: [2])
  bus("b3", (7.2, 0), length: 1.4, angle: 90deg, label: [3])
  external-grid("g", (0.6, 0), angle: 90deg,
    label: (content: align(center)[150 MVA, \ 10 kV],
            anchor: "north", distance: 0.25))
  wire("g.in", "b1.mid")
  transformer("t", "b1.mid", "b2.mid",
    primary-stroke: 0.8pt + red, label: [10/0.4 kV])
  wire("b2.mid", "b3.mid")
  breaker("q", (5.6, 0), kind: "cross")
  load("l2", bus-frac("b2", 1/6), elbow: 0.4,
    fill: flex, stroke: flex, label: (content: [flex], anchor: "east"))
  pv-panel("pv", bus-frac("b3", 0.3), elbow: 0.9)
  load("l3", bus-frac("b3", 1/6), elbow: 0.4, label: [4 MW])
})
