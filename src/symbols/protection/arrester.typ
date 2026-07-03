// Surge arrester — overvoltage protection. The IEC convention: a
// rectangle on the conductor with a filled arrow inside pointing
// toward the earthed side. Ubiquitous in substation one-lines, where
// it hangs as a shunt between a phase conductor and earth.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Surge arrester. Two-node: pass `in` (the protected conductor side)
/// and `out` (the earthed side); the body sits at the midpoint with
/// leads to the two endpoints, and the internal arrow points from
/// `in` toward `out`. Terminate `out` on a `ground()` for the usual
/// shunt form.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`, `east`, `west` (box sides).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints.
/// - length (float): length of the body along the lead axis.
/// - width (float): width of the body perpendicular to the leads.
/// - head-length (float): length of the arrowhead inside the body.
/// - head-width (float): width of the arrowhead.
/// - head-fill (color | auto): arrowhead fill; `auto` uses the stroke
///   paint (the conventional solid head).
/// - stroke: standard style override.
/// - fill: body fill (default `none`).
/// - label: standard label dict.
/// -> content
#let arrester(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let len = style.at("length", default: 0.6)
    let w = style.at("width", default: 0.26)
    let hl = style.at("head-length", default: 0.2)
    let hw = style.at("head-width", default: 0.15)
    let hf = style.at("head-fill", default: auto)
    if hf == auto {
      let p = std.stroke(s).paint
      hf = if p == auto { black } else { p }
    }

    if positions.len() != 2 {
      assert(false, message: "arrester() requires two positions (in, out)")
    }

    let span = cetz.vector.dist(positions.at(0), positions.at(1))
    let half = span / 2
    let half-len = len / 2

    let wire-stroke = ctx
      .style
      .at("cetz-power", default: (:))
      .at("wire", default: (:))
      .at("stroke", default: s)
    if half > half-len {
      cetz.draw.line((-half, 0), (-half-len, 0), stroke: wire-stroke)
      cetz.draw.line((half-len, 0), (half, 0), stroke: wire-stroke)
    }

    // Body rectangle.
    cetz.draw.rect(
      (-half-len, -w / 2),
      (half-len, w / 2),
      stroke: s,
      fill: f,
    )
    // Arrow inside, pointing toward `out`: shaft from the in-side
    // edge, solid head with its tip on the out-side inner edge.
    let tip = half-len - 0.04
    cetz.draw.line((-half-len, 0), (tip - hl, 0), stroke: s)
    cetz.draw.line(
      (tip - hl, hw / 2),
      (tip, 0),
      (tip - hl, -hw / 2),
      close: true,
      stroke: s,
      fill: hf,
    )

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, w / 2))
    cetz.draw.anchor("south", (0, -w / 2))
    cetz.draw.anchor("east", (half-len, 0))
    cetz.draw.anchor("west", (-half-len, 0))
  }

  symbol("arrester", name, ..positions, ..overrides, draw: draw)
}
