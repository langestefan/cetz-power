// Current source — circle with an internal arrow showing the
// reference direction (in → out). Two-node placement: the arrow
// always points along the local +x axis, which after the symbol()
// rotation lands along the in→out direction in world space.
//
// `kind: "ac"` overlays a small sine squiggle on top of the arrow,
// matching the IEC notation for an AC current source.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Current source. Two-node: pass `in` and `out` and the arrow
/// inside the circle points along the in→out direction.
///
/// Anchors: `in`, `out`, `center`, `north`, `south`, `east`, `west`.
///
/// - name (str): CeTZ group name.
/// - radius (float): body-circle radius.
/// - kind (str): `"dc"` (default) or `"ac"`. AC adds a small sine
///   wave above the arrow.
/// - stroke / fill: standard style overrides.
/// - label: standard label dict.
/// -> content
#let currentsource(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let r = style.at("radius", default: 0.3)
    let kind = style.at("kind", default: "dc")

    let x-left = -r
    let x-right = r

    if positions.len() == 2 {
      let span = cetz.vector.dist(positions.at(0), positions.at(1))
      let half = span / 2
      if half > x-right {
        let wire-stroke = ctx.style
          .at("cetz-power", default: (:))
          .at("wire", default: (:))
          .at("stroke", default: s)
        cetz.draw.line((-half, 0), (x-left, 0), stroke: wire-stroke)
        cetz.draw.line((x-right, 0), (half, 0), stroke: wire-stroke)
      }
    }

    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)

    // Arrow inside the circle, pointing from -x to +x (in→out).
    let arrow-y = if kind == "ac" { -r * 0.2 } else { 0 }
    cetz.draw.line(
      (-r * 0.5, arrow-y), (r * 0.5, arrow-y),
      stroke: s,
      mark: (end: ">", fill: black, scale: 0.7),
    )

    if kind == "ac" {
      // Small sine-wave above the arrow.
      let amp = r * 0.18
      let half-w = r * 0.45
      let pts = ()
      let n = 20
      for i in range(n + 1) {
        let t = i / n
        let x = -half-w + 2 * half-w * t
        let y = r * 0.25 + amp * calc.sin(2 * calc.pi * t)
        pts.push((x, y))
      }
      cetz.draw.line(..pts, stroke: s)
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, r + 0.05))
    cetz.draw.anchor("south", (0, -r - 0.05))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("currentsource", name, ..positions, ..overrides, draw: draw)
}
