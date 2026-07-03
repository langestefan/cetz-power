// Device block — a labelled rectangular box for the "black box"
// elements of a network diagram: wind plants, batteries, PV parks,
// controllers, or any device whose internals are out of scope. The
// box carries optional content centred inside it (the device name)
// and is wired up through its compass anchors.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Device block. One-node: pass a single position and the box centres
/// on it — wire it up via the compass anchors. Two-node: pass `in` and
/// `out` and the body sits at the midpoint with leads to the two
/// endpoints, oriented along in→out.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`, `east`, `west` (edge midpoints), plus the four corners
/// (`north-west`, `north-east`, `south-west`, `south-east`).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints (or one point).
/// - body (content): content drawn centred inside the box (the device
///   name, e.g. `[wind]`). Default `none` — an empty box.
/// - body-size (length): font size for `body`. Default `8pt`.
/// - width, height (float): box dimensions.
/// - stroke: box outline.
/// - fill: box fill — the conventional way to colour-code devices.
/// - label: standard label dict (default anchor `"south"`) for a
///   caption *outside* the box.
/// -> content
#let block(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let w = style.at("width", default: 1.15)
    let h = style.at("height", default: 0.55)
    let body = style.at("body", default: none)
    let body-size = style.at("body-size", default: 8pt)

    if positions.len() > 2 {
      assert(false, message: "block() takes one or two positions")
    }

    let hw = w / 2
    let hh = h / 2
    let span = if positions.len() == 2 {
      cetz.vector.dist(positions.at(0), positions.at(1))
    } else { 0 }
    let half = span / 2

    // Two-node placement: leads from the endpoints to the box edges,
    // drawn in wire style (same heuristic as breaker / converter).
    if half > hw {
      let wire-stroke = ctx
        .style
        .at("cetz-power", default: (:))
        .at("wire", default: (:))
        .at("stroke", default: s)
      cetz.draw.line((-half, 0), (-hw, 0), stroke: wire-stroke)
      cetz.draw.line((hw, 0), (half, 0), stroke: wire-stroke)
    }

    cetz.draw.rect((-hw, -hh), (hw, hh), stroke: s, fill: f)
    if body != none {
      cetz.draw.content((0, 0), text(size: body-size, body))
    }

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, hh))
    cetz.draw.anchor("south", (0, -hh))
    cetz.draw.anchor("east", (hw, 0))
    cetz.draw.anchor("west", (-hw, 0))
    cetz.draw.anchor("north-west", (-hw, hh))
    cetz.draw.anchor("north-east", (hw, hh))
    cetz.draw.anchor("south-west", (-hw, -hh))
    cetz.draw.anchor("south-east", (hw, -hh))
  }

  symbol("block", name, ..positions, ..overrides, draw: draw)
}
