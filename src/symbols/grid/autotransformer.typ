// Autotransformer — single-line IEC form: one circle (the common
// winding) with the through-conductor detouring around one side of it
// in an open loop (the series winding). Distinguishes an
// autotransformer from the two-circle two-winding symbol.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Autotransformer. Place with two positions (in and out) or one
/// position plus `angle:`. The conductor runs in → loop → out; the
/// loop bulges toward local "north" and rejoins the axis on the
/// circle's out-side edge.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north` (top
/// of the loop), `south`, `east`, `west`.
///
/// - name (str): CeTZ group name.
/// - radius (float): circle radius (the loop scales with it).
/// - oltc (bool): `true` draws the on-load tap-changer arrow through
///   the body (autotransformers usually carry one).
/// - oltc-stroke: stroke for the OLTC arrow.
/// - stroke / fill: standard style overrides.
/// - label: standard label dict.
/// -> content
#let autotransformer(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.32)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)

    // Loop geometry (proportions from the IEC glyph): the conductor
    // leaves the axis at 1.4r before the circle centre, bulges to
    // 1.44r laterally, and rejoins the axis on the circle's far edge.
    let a = -1.4 * r // loop start on the axis
    let b = r // loop end = circle out-side edge
    let bulge = 1.44 * r

    if positions.len() == 2 {
      let span = cetz.vector.dist(positions.at(0), positions.at(1))
      let half = span / 2
      if half > -a {
        cetz.draw.line((-half, 0), (a, 0), stroke: s)
      }
      if half > b {
        cetz.draw.line((b, 0), (half, 0), stroke: s)
      }
    }

    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)
    // The series-winding loop: a smooth bulge overlapping the circle.
    cetz.draw.bezier((a, 0), (b, 0), (a, bulge), (b, bulge), stroke: s)

    if style.at("oltc", default: false) {
      let os = style.at("oltc-stroke", default: 0.7pt + black)
      let paint = std.stroke(os).paint
      if paint == auto { paint = black }
      cetz.draw.line(
        (-1.2 * r, -1.45 * r),
        (1.2 * r, 1.45 * r),
        stroke: os,
        mark: (end: ">", fill: paint, scale: 0.5),
      )
    }

    cetz.draw.anchor("in", (a, 0))
    cetz.draw.anchor("out", (b, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, 1.08 * r + 0.05))
    cetz.draw.anchor("south", (0, -r - 0.05))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
    cetz.draw.anchor("default", (0, 0))
  }

  symbol("autotransformer", name, ..positions, ..overrides, draw: draw)
}
