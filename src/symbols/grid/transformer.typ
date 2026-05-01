// Two-winding transformer — drawn as two overlapping circles along the
// connection line. Naturally a two-node element: give it the `in` and
// `out` coordinates and it orients itself along that line, drawing leads
// from each endpoint to the corresponding circle.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Two-winding transformer. Place with two positions (in and out) or one
/// position plus `angle:`.
///
/// The two windings can be styled independently — `primary-stroke` /
/// `primary-fill` apply to the LEFT (in-side) circle and its lead;
/// `secondary-stroke` / `secondary-fill` apply to the RIGHT (out-side)
/// circle and its lead. Both default to the unified `stroke` / `fill`,
/// so callers that don't care about per-winding colouring see the
/// previous behaviour.
///
/// - name (str): CeTZ group name
/// - radius (float): radius of each circle (style override)
/// - distance (float): centre-to-centre distance between the two circles
/// - stroke / fill: stroke and fill applied to BOTH circles (and both
///   leads when `primary-stroke` / `secondary-stroke` aren't set).
/// - primary-stroke / primary-fill: per-side override for the left
///   (in-side) winding. Defaults to `stroke` / `fill`.
/// - secondary-stroke / secondary-fill: per-side override for the right
///   (out-side) winding. Defaults to `stroke` / `fill`.
/// - label: optional label
/// -> content
#let transformer(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.32)
    let d = style.at("distance", default: 0.42)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let ps = style.at("primary-stroke", default: s)
    let ss = style.at("secondary-stroke", default: s)
    let pf = style.at("primary-fill", default: f)
    let sf = style.at("secondary-fill", default: f)

    let x-left = -d / 2 - r
    let x-right = d / 2 + r

    // Two-node placement: when the user-supplied span is wider than the
    // symbol's own circles, draw leads from each endpoint to the outer
    // edge of the corresponding circle. If the span is narrower, just
    // leave the symbol in place (drawing a "negative" lead would put a
    // wire on top of the circle).
    //
    // Each lead picks up the per-winding stroke (primary or secondary),
    // so a transformer with `primary-stroke: red` gets a red lead AND a
    // red primary circle — the lead matches the winding it serves.
    if positions.len() == 2 {
      let span = cetz.vector.dist(positions.at(0), positions.at(1))
      let half = span / 2
      if half > x-right {
        cetz.draw.line((-half, 0), (x-left, 0), stroke: ps)
        cetz.draw.line((x-right, 0), (half, 0), stroke: ss)
      }
    }

    // Circles centred symmetrically around the symbol origin. Fills are
    // drawn in their own pass so the second circle's fill doesn't occlude
    // the first circle's stroke in the overlap region.
    cetz.draw.circle((-d / 2, 0), radius: r, stroke: none, fill: pf)
    cetz.draw.circle((d / 2, 0), radius: r, stroke: none, fill: sf)
    cetz.draw.circle((-d / 2, 0), radius: r, stroke: ps, fill: none)
    cetz.draw.circle((d / 2, 0), radius: r, stroke: ss, fill: none)

    cetz.draw.anchor("in", (x-left, 0))
    cetz.draw.anchor("out", (x-right, 0))
    cetz.draw.anchor("primary", (x-left, 0))
    cetz.draw.anchor("secondary", (x-right, 0))
    cetz.draw.anchor("center", (0, 0))
    // north/south sit slightly outside the circles so labels clear them
    cetz.draw.anchor("north", (0, r + 0.05))
    cetz.draw.anchor("south", (0, -r - 0.05))
    cetz.draw.anchor("east", (x-right, 0))
    cetz.draw.anchor("west", (x-left, 0))
    cetz.draw.anchor("default", (0, 0))
  }

  symbol("transformer", name, ..positions, ..overrides, draw: draw)
}
