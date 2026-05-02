#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Two-node version: pass two coordinates and `symbol()` rotates the
// draw closure so its local +x axis points from `in` to `out`. We
// just draw an arrow-headed segment along that axis.
//
// `length` is the world-space distance between in and out, available
// to the closure as `cetz.vector.dist(positions.first(), positions.last())`.
#let arrow-link(name, a, b, ..overrides) = {
  let draw(ctx, positions, style) = {
    let len = cetz.vector.dist(positions.first(), positions.last())
    let s = style.at("stroke", default: 0.8pt + black)
    cetz.draw.line(
      (0, 0), (len, 0),
      stroke: s,
      mark: (end: ">", fill: s.paint),
    )
  }
  symbol("arrow-link", name, a, b, ..overrides, draw: draw)
}

#diagram(length: 1cm, {
  bus("b1", (0, 0), length: 1.4, angle: 90deg, label: [Source])
  bus("b2", (3, 0), length: 1.4, angle: 90deg, label: [Sink])
  arrow-link("flow", "b1.mid", "b2.mid", stroke: 1.2pt + blue)
})
