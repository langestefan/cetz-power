// Fuse — overcurrent protection device. Drawn as a rectangle with a
// straight wire passing through it (the IEC convention). Two-node
// placement only — the fuse always spans between two endpoints.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Fuse. Two-node: pass `in` and `out` and the body sits at the
/// midpoint with leads to the two endpoints.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`.
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints.
/// - length (float): length of the rectangular body along the lead axis.
/// - width (float): width of the body perpendicular to the leads.
/// - stroke: standard style override.
/// - fill: body fill (default `none`).
/// - label: standard label dict.
/// -> content
#let fuse(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let len = style.at("length", default: 0.6)
    let w = style.at("width", default: 0.22)

    if positions.len() != 2 {
      assert(false, message: "fuse() requires two positions (in, out)")
    }

    let span = cetz.vector.dist(positions.at(0), positions.at(1))
    let half = span / 2
    let half-len = len / 2

    let wire-stroke = ctx.style
      .at("cetz-power", default: (:))
      .at("wire", default: (:))
      .at("stroke", default: s)
    if half > half-len {
      cetz.draw.line((-half, 0), (-half-len, 0), stroke: wire-stroke)
      cetz.draw.line((half-len, 0), (half, 0), stroke: wire-stroke)
    }

    // Body rectangle.
    cetz.draw.rect(
      (-half-len, -w / 2), (half-len, w / 2),
      stroke: s, fill: f,
    )
    // Wire through the body — the fuse element. Drawn last so it
    // sits on top of the rectangle's fill.
    cetz.draw.line((-half-len, 0), (half-len, 0), stroke: s)

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, w / 2))
    cetz.draw.anchor("south", (0, -w / 2))
    cetz.draw.anchor("east", (half-len, 0))
    cetz.draw.anchor("west", (-half-len, 0))
  }

  symbol("fuse", name, ..positions, ..overrides, draw: draw)
}
