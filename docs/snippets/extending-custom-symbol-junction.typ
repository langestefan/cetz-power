#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Define a one-off `junction` symbol right in the document — same
// `symbol()` primitive the built-in symbols use. Useful for marking
// a tee where two wires meet on a shared bus.
#let junction(name, pos, ..overrides) = {
  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.06)
    let f = style.at("fill", default: black)
    let s = style.at("stroke", default: 0.6pt + black)
    cetz.draw.circle((0, 0), radius: r, fill: f, stroke: s)
    // The wrapper exposes `in`/`out` automatically; we add the four
    // compass anchors so callers can wire to whichever side is
    // closer without computing offsets by hand.
    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("north", (0,  r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east",  ( r, 0))
    cetz.draw.anchor("west",  (-r, 0))
  }
  symbol("junction", name, pos, ..overrides, draw: draw)
}

#diagram(length: 1cm, {
  bus("b", (0, 0), length: 4, taps: 3)
  // Two loads tapped into the same point on the bus, and a junction
  // dot at the tee so the connection reads as electrical (not just a
  // visual crossover).
  junction("j", "b.tap2")
  load("ld1", (rel: (-0.8, -1)), elbow: -0.8)
  wire("j.south", "ld1.in")
  load("ld2", (rel: (0.8, -1), to: "j"), elbow: 0.8)
  wire("j.south", "ld2.in")
})
