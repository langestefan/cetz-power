#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Colour-coded device blocks, each tying in through its own
  // transformer — the wind / BESS / PV row of a plant diagram.
  bus("mv", (1.0, 1.4), (6.6, 1.4))
  let dev(name, x, fill, lbl) = {
    block(name, (x, 0), body: lbl, fill: fill)
    transformer(
      name + "-t",
      (x + 1.0, 0),
      (x + 1.0, 1.4),
      radius: 0.16,
      distance: 0.15,
    )
    wire(name + ".east", (x + 1.0, 0))
  }
  dev("wind", 0.6, rgb("#9cdcf0"), [wind])
  dev("bess", 2.8, rgb("#f3c9ea"), [BESS])
  dev("pv", 5.0, rgb("#f5b426"), [PV])
})
