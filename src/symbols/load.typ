// Load — filled downward arrow, the standard "generic load" symbol on a bus.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Generic load — filled arrow pointing away from the connection point.
///
/// By default the arrow points south (so, dangling below the connection).
/// Rotate with `angle:` to make it point elsewhere.
///
/// - name (str): CeTZ group name
/// - size (float): arrow length
/// - lead (float): length of the stub wire from the connection point to the arrow's base
/// - elbow (float): if non-zero, route the lead as an L-shape — stepping
///   horizontally by `elbow` units and then dropping down to the arrow
/// -> content
#let load(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()
  let lead = overrides.at("lead", default: none)
  if lead != none { let _ = overrides.remove("lead") }
  let elbow = overrides.at("elbow", default: none)
  if elbow != none { let _ = overrides.remove("elbow") }

  let draw(ctx, positions, style) = {
    let sz = style.at("size", default: 0.35)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: black)
    let l = if lead != none { lead } else { style.at("lead", default: 0.3) }
    let e = if elbow != none { elbow } else { 0 }

    // Lead: either a straight stub down, or an L-shape (across by `e`,
    // then down by `l`). The arrow's base is at the bottom of the stub.
    let arrow-x = e
    let arrow-base-y = -l
    if e == 0 {
      if l > 0 {
        cetz.draw.line((0, 0), (0, -l), stroke: s)
      }
    } else {
      cetz.draw.line((0, 0), (e, 0), (e, -l), stroke: s)
    }
    // Triangle pointing down: a flat top edge and a tip `sz` below it.
    // With `fill: none` (the default) this gives the textbook hollow-arrow
    // load symbol; pass `fill: black` for the filled "engineering" form.
    let top-left  = (arrow-x - sz / 2, arrow-base-y)
    let top-right = (arrow-x + sz / 2, arrow-base-y)
    let tip       = (arrow-x, arrow-base-y - sz)
    cetz.draw.line(
      top-left, top-right, tip,
      close: true,
      stroke: s,
      fill: f,
    )

    cetz.draw.anchor("tip", tip)
    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    // Compass anchors — "north" is the connection point, "south" is the arrow tip,
    // "east"/"west" sit at the arrow body edges.
    cetz.draw.anchor("north", (0, 0))
    cetz.draw.anchor("south", tip)
    cetz.draw.anchor("east", (arrow-x + sz / 2, arrow-base-y - sz / 2))
    cetz.draw.anchor("west", (arrow-x - sz / 2, arrow-base-y - sz / 2))
    // Label anchors: just outside the arrow body — close enough to read as
    // "this label belongs to this load", far enough not to overlap.
    cetz.draw.anchor("label-east", (arrow-x + sz / 2 + 0.1, arrow-base-y - sz / 2))
    cetz.draw.anchor("label-west", (arrow-x - sz / 2 - 0.1, arrow-base-y - sz / 2))
  }

  symbol("load", name, ..positions, ..overrides, draw: draw)
}
