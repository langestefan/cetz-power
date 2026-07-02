// Connection point (net node) — the small circle drawn on a conductor
// in distribution-network overview diagrams. A filled circle is a
// closed (connected) point; a hollow circle is an open point — the
// "netopening" that marks where a normally-open ring is split.
//
// The open variant paints its interior, masking the conductor drawn
// beneath it — so draw junctions *after* the wires they sit on.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Connection point on a conductor. One-node: place it on a wire,
/// bus or line corner.
///
/// Anchors: `center` (= `in`/`out`) plus `north`, `south`, `east`,
/// `west` on the circle, so a wire can also stop at its edge.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): the connection point.
/// - radius (float): circle radius.
/// - open (bool): `false` (default) draws a filled dot — a closed
///   connection; `true` draws a hollow circle — an open point.
/// - fill: override the body paint. Default `auto`: the stroke's
///   paint when closed, `white` when open (masking the wire below).
/// - stroke: standard style override.
/// - label: standard label dict.
/// -> content
#let junction(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.09)
    let s = style.at("stroke", default: 0.8pt + black)
    let is-open = style.at("open", default: false)
    let f = style.at("fill", default: auto)
    if f == auto {
      f = if is-open { white } else {
        let paint = stroke(s).paint
        if paint == auto { black } else { paint }
      }
    }

    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, r))
    cetz.draw.anchor("south", (0, -r))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("junction", name, ..positions, ..overrides, draw: draw)
}
