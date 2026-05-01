// Photovoltaic panel — a rectangle with a small downward-pointing
// triangle inside the top, indicating a (DC) source flowing out of the
// connection point at the top of the rectangle.
//
// Single-terminal: connect at the `in` anchor at the top of the panel.
// Use `elbow:` to route the lead as an L-shape (across, then down).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Solar / photovoltaic panel.
///
/// - name (str): CeTZ group name
/// - size (float): panel width
/// - aspect (float): height-to-width ratio of the panel rectangle
/// - lead (float): stub from connection point to the top of the panel
/// - elbow (float): if non-zero, route the lead as an L-shape — step
///   horizontally by `elbow` units, then drop down to the panel
/// -> content
#let pv-panel(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()
  let lead = overrides.at("lead", default: none)
  if lead != none { let _ = overrides.remove("lead") }
  let elbow = overrides.at("elbow", default: none)
  if elbow != none { let _ = overrides.remove("elbow") }

  let draw(ctx, positions, style) = {
    let w = style.at("size", default: 0.5)
    let h = w * style.at("aspect", default: 1.4)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let l = if lead != none { lead } else { style.at("lead", default: 0.25) }
    let e = if elbow != none { elbow } else { 0 }

    // Lead from origin (connection point) to the panel's top edge.
    // Same shape rules as `load`: straight if elbow == 0, L-shape otherwise.
    let panel-x = e
    let panel-top-y = -l
    if e == 0 {
      if l > 0 {
        cetz.draw.line((0, 0), (0, -l), stroke: s)
      }
    } else {
      cetz.draw.line((0, 0), (e, 0), (e, -l), stroke: s)
    }

    // Panel rectangle — top edge centred at (panel-x, panel-top-y),
    // extending downward by h.
    let left   = panel-x - w / 2
    let right  = panel-x + w / 2
    let top    = panel-top-y
    let bottom = panel-top-y - h
    cetz.draw.rect((left, bottom), (right, top), stroke: s, fill: f)

    // Downward triangle inside the top of the panel. We draw only the
    // two diagonal sides — the rectangle's top edge already serves as
    // the triangle's base, so closing the triangle would double-stroke
    // that edge and the corner joins would visibly stick out past the
    // rectangle's corners.
    let th = h * style.at("triangle-height", default: 0.45)
    let tri-bottom = top - th
    let tri-fill = style.at("triangle-fill", default: none)
    if tri-fill != none {
      // Filled variant: explicitly paint the closed triangle (no extra
      // base stroke is drawn because we use stroke: none for the fill,
      // and the visible outline is provided by the two diagonal lines
      // we add right after).
      cetz.draw.line(
        (left,    top),
        (right,   top),
        (panel-x, tri-bottom),
        close: true,
        stroke: none,
        fill: tri-fill,
      )
    }
    cetz.draw.line((left,  top), (panel-x, tri-bottom), stroke: s)
    cetz.draw.line((right, top), (panel-x, tri-bottom), stroke: s)

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in",      (0, 0))
    cetz.draw.anchor("north",   (0, 0))
    cetz.draw.anchor("south",   (panel-x, bottom))
    cetz.draw.anchor("east",    (right, (top + bottom) / 2))
    cetz.draw.anchor("west",    (left,  (top + bottom) / 2))
    cetz.draw.anchor("center",  (panel-x, (top + bottom) / 2))
  }

  symbol("pv-panel", name, ..positions, ..overrides, draw: draw)
}
