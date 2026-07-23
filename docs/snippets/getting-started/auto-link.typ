#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // One call per connection — the shape follows from the bars'
  // geometry, and every end taps a bar interior, never a tip.
  bus("a", (0, 0), length: 2, label: [A])
  bus("b", (4.5, 0), length: 2, label: [B])
  link("a", "b", label: [tie cable]) // collinear → U around the bars

  bus("c", (0, -2.2), length: 2.5)
  bus("d", (0.4, -4.4), length: 2.5)
  link("c", "d", from: 0.3, label: [500 m]) // facing → straight

  bus("e", (4.5, -2.2), length: 1.6)
  bus("f", (7.5, -4.4), length: 1.6)
  link("e", "f") // offset → Z between the bars

  bus("g", (9.5, 0), length: 1.8)
  bus("h", (12, -1.4), length: 1.8, angle: 90deg)
  link("g", "h", to: 0.65) // perpendicular → L
})
