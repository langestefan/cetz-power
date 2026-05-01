// Inductor — the IEEE/American "looped" form: a series of semicircular
// bumps along the lead axis. The European IEC rectangle form would
// look identical to the resistor symbol on its own, so we ship the
// looped form by default — it's unambiguous in single-line diagrams.
//
// Default form is the symmetric two-pole textbook inductor: a lead
// from `in`, four bumps, then a matching upper lead ending at `out`.
// Pass `lead-out: 0` for the single-pole / shunt form.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Inductor — a chain of semicircular bumps with a lead at each end.
///
/// Default orientation: `in` at the bottom, `out` at the top, bumps
/// stacked along the centerline bulging out to the right (positive x
/// in the local frame). Pass `angle:` to rotate.
///
/// Anchors: `in` (= `default`, = `south`), `out` (top of the upper
/// lead — present only when `lead-out > 0`), `north` (top of the
/// upper lead, or the top of the bumps if `lead-out: 0`), `east` and
/// `west` (sides at the midpoint of the bump column), `center`
/// (midpoint of the bump column on the centerline).
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): connection point — the `in` anchor lands here.
/// - bumps (int): number of semicircular bumps (default `4`).
/// - bump-radius (float): radius of each bump.
/// - lead-in (float): length of the lead from `in` up to the first bump.
/// - lead-out (float): length of the lead after the last bump. Default
///   non-zero (symmetric two-pole). Set to `0` for the single-pole
///   / shunt form.
/// - stroke: stroke for both leads and the bumps.
/// - label: standard label dict.
/// - angle (angle): rotation around the connection point.
/// -> content
#let inductor(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let n = style.at("bumps", default: 4)
    let r = style.at("bump-radius", default: 0.1)
    let li = style.at("lead-in", default: 0.2)
    let lo = style.at("lead-out", default: 0.2)

    let bumps-len = n * 2 * r
    let bottom-y = li
    let top-y = bottom-y + bumps-len
    let mid-y = (bottom-y + top-y) / 2
    let out-y = top-y + lo

    if li > 0 { cetz.draw.line((0, 0), (0, bottom-y), stroke: s) }

    // Each bump is a semicircle starting at (0, y0), arcing CCW from
    // angle -90 to +90 with the given radius. The arc's centre lands
    // at (0, y0 + r); the arc ends at (0, y0 + 2r), and the bump
    // bulges out to +x along the way.
    for i in range(n) {
      let y0 = bottom-y + i * 2 * r
      cetz.draw.arc(
        (0, y0),
        start: -90deg,
        stop: 90deg,
        radius: r,
        stroke: s,
        anchor: "start",
      )
    }

    if lo > 0 { cetz.draw.line((0, top-y), (0, out-y), stroke: s) }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("center", (0, mid-y))
    // east is at the rightmost extent of the bumps (+r from centerline)
    cetz.draw.anchor("east", (r, mid-y))
    cetz.draw.anchor("west", (0, mid-y))
    // `out` always points at the body's far end (the upper lead when
    // lead-out > 0, otherwise the top plate / top of the bumps). The
    // outer symbol() wrapper sets a default "out" at the placement
    // point for one-node symbols, which would silently collide with
    // `in`; we override it here so chaining wires off `out` always
    // works regardless of the lead-out value.
    let north-y = if lo > 0 { out-y } else { top-y }
    cetz.draw.anchor("out", (0, north-y))
    cetz.draw.anchor("north", (0, north-y))
  }

  symbol("inductor", name, ..positions, ..overrides, draw: draw)
}
