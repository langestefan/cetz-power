// Voltage transformer (VT / PT) — instrument transformer for voltage
// measurement. IEC one-line convention: a small two-winding
// transformer (two overlapping circles) hanging off a tap on the
// measured conductor.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Voltage transformer. One-node: the tap point is `in` (the origin);
/// a short lead runs down to the primary circle and the secondary
/// circle overlaps below it — the whole symbol hangs below the tap.
/// Rotate with `angle:` (`180deg` points it upward).
///
/// Anchors: `in` / `north` (the tap), `out` / `south` (bottom of the
/// secondary circle — wire the measurement drop from here), `center`
/// (between the circles), `east`, `west`.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): tap point on the measured conductor.
/// - radius (float): circle radius.
/// - distance (float): centre-to-centre spacing of the two circles.
/// - lead (float): stub from the tap down to the primary circle.
/// - stroke / fill: standard style overrides.
/// - label: standard label dict.
/// - angle (angle): rotation around the tap point.
/// -> content
#let vt(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let r = style.at("radius", default: 0.14)
    let d = style.at("distance", default: 0.14)
    let lead = style.at("lead", default: 0.15)

    let c1 = -(lead + r) // primary circle centre
    let c2 = c1 - d // secondary circle centre
    let bot = c2 - r

    if lead > 0 {
      cetz.draw.line((0, 0), (0, -lead), stroke: s)
    }
    cetz.draw.circle((0, c1), radius: r, stroke: s, fill: f)
    cetz.draw.circle((0, c2), radius: r, stroke: s, fill: f)

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("north", (0, 0))
    cetz.draw.anchor("center", (0, (c1 + c2) / 2))
    cetz.draw.anchor("east", (r, (c1 + c2) / 2))
    cetz.draw.anchor("west", (-r, (c1 + c2) / 2))
    cetz.draw.anchor("out", (0, bot))
    cetz.draw.anchor("south", (0, bot))
  }

  symbol("vt", name, ..positions, ..overrides, draw: draw)
}
