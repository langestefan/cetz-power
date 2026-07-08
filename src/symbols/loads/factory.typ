// Factory — industrial-consumer pictogram: a building with a sawtooth
// roof, a steam pipe standing on the roof base, and a row of window
// dashes, enclosed in a rectangular box (the same device-box look as
// `plant` / `block`). Pass `box: false` for the bare building.
//
// Single-terminal: the lead drops from the connection point onto the
// box top (or, bare, onto the pipe top — the symbol's highest point,
// so the lead never crosses the roofline). Use `elbow:` to route the
// lead as an L-shape.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Factory / industrial load.
///
/// - name (str): CeTZ group name
/// - width (float): building width (the box adds padding around it)
/// - height (float): building height, pipe top to ground
/// - lead (float): stub from connection point to the box (or pipe) top
/// - elbow (float): if non-zero, route the lead as an L-shape — step
///   horizontally by `elbow` units, then drop down to the symbol
/// - box (bool): enclose the building in a rectangular device box
/// - teeth (int): number of sawtooth roof teeth
/// - windows (int): number of window dashes along the bottom
/// - smoke (bool): draw two smoke wisps drifting off the pipe
/// -> content
#let factory(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()
  let lead = overrides.at("lead", default: none)
  if lead != none { let _ = overrides.remove("lead") }
  let elbow = overrides.at("elbow", default: none)
  if elbow != none { let _ = overrides.remove("elbow") }

  let draw(ctx, positions, style) = {
    let w = style.at("width", default: 0.8)
    let h = style.at("height", default: 0.7)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let n = style.at("windows", default: 3)
    let boxed = style.at("box", default: true)
    let smoke = style.at("smoke", default: false)
    let l = if lead != none { lead } else { style.at("lead", default: 0.25) }
    let e = if elbow != none { elbow } else { 0 }

    // Lead from origin (connection point) down to the symbol top. Same
    // shape rules as `load`: straight if elbow == 0, L-shape otherwise.
    if e == 0 {
      if l > 0 {
        cetz.draw.line((0, 0), (0, -l), stroke: s)
      }
    } else {
      cetz.draw.line((0, 0), (e, 0), (e, -l), stroke: s)
    }

    // Steam-pipe geometry — the pipe stands on a short flat ledge at
    // roof-base height on the far left of the building. The roof-side
    // margin is wider than the wall-side one so the pipe keeps clear
    // daylight to the first sawtooth tooth.
    let pw = w * style.at("pipe-width", default: 0.15)
    let ml = 0.05 * w // ledge margin, wall side
    let mr = 0.11 * w // ledge margin, roof side
    let ledge = ml + pw + mr

    // Placement. Boxed: the box hangs centred under the lead with the
    // building centred inside (extra top padding when smoke is on, so
    // the wisps stay inside the box). Bare: the pipe's centreline
    // carries the lead.
    let left = 0
    let top = 0
    let (box-l, box-r, box-t, box-b) = (0, 0, 0, 0)
    if boxed {
      let padx = 0.12 * w
      let padt = if smoke { 0.34 * h } else { 0.10 * h }
      let padb = 0.10 * h
      box-l = e - w / 2 - padx
      box-r = e + w / 2 + padx
      box-t = -l
      box-b = box-t - padt - h - padb
      left = e - w / 2
      top = box-t - padt
      cetz.draw.rect(
        (box-l, box-b),
        (box-r, box-t),
        stroke: s,
        fill: style.at("box-fill", default: none),
      )
    } else {
      left = e - ml - pw / 2
      top = -l
    }
    let right = left + w
    let ground = top - h
    let px = left + ml + pw / 2 // pipe centreline

    // Building outline — one closed polygon: left wall up to the roof
    // base, the ledge, then the sawtooth teeth (vertical rise, slope
    // down-right), right wall at valley height.
    let n-teeth = style.at("teeth", default: 3)
    let peak = ground + h * 0.72 // sawtooth peak height
    let valley = ground + h * 0.50 // roof base / sawtooth valley
    let tooth = (w - ledge) / n-teeth
    // Pipe body fill first, so the outline stroke (the ledge segment
    // crossing the pipe base) stays fully visible on top of it.
    if f != none {
      cetz.draw.rect(
        (px - pw / 2, valley),
        (px + pw / 2, top),
        stroke: none,
        fill: f,
      )
    }
    let outline = ((left, ground), (left, valley), (left + ledge, valley))
    for i in range(n-teeth) {
      outline.push((left + ledge + i * tooth, peak))
      outline.push((left + ledge + (i + 1) * tooth, valley))
    }
    outline.push((right, ground))
    cetz.draw.line(..outline, close: true, stroke: s, fill: f)

    // Steam pipe — an open-bottomed rectangle whose side walls end on
    // the ledge, so the pipe connects only at the base of the roof.
    cetz.draw.line(
      (px - pw / 2, valley),
      (px - pw / 2, top),
      (px + pw / 2, top),
      (px + pw / 2, valley),
      stroke: s,
    )

    // Window dashes — small filled rounded rectangles, evenly spread
    // along the bottom of the building.
    let wf = style.at("window-fill", default: auto)
    if wf == auto {
      let paint = std.stroke(s).paint
      wf = if paint == auto { black } else { paint }
    }
    let ww = w * 0.15
    let wh = h * 0.10
    let wy = ground + h * 0.22
    for i in range(n) {
      let wx = left + w * (i + 1) / (n + 1)
      cetz.draw.rect(
        (wx - ww / 2, wy - wh / 2),
        (wx + ww / 2, wy + wh / 2),
        radius: wh * 0.4,
        stroke: none,
        fill: wf,
      )
    }

    // Optional smoke — two wisps drifting right off the pipe mouth.
    // They stay right of the (vertical) lead and low enough to clear
    // the box top (boxed) or a default-length lead and the bus above
    // it (bare).
    if smoke {
      cetz.draw.bezier(
        (px + 0.10 * w, top + 0.05 * h),
        (px + 0.50 * w, top + 0.09 * h),
        (px + 0.22 * w, top + 0.14 * h),
        (px + 0.36 * w, top + 0.00 * h),
        stroke: s,
      )
      cetz.draw.bezier(
        (px + 0.14 * w, top + 0.17 * h),
        (px + 0.56 * w, top + 0.21 * h),
        (px + 0.26 * w, top + 0.26 * h),
        (px + 0.42 * w, top + 0.12 * h),
        stroke: s,
      )
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("north", (0, 0))
    cetz.draw.anchor("pipe", (px, top))
    if boxed {
      // Compass anchors on the box, like `block` / `plant`.
      let box-mid = (box-t + box-b) / 2
      cetz.draw.anchor("south", (e, box-b))
      cetz.draw.anchor("east", (box-r, box-mid))
      cetz.draw.anchor("west", (box-l, box-mid))
      cetz.draw.anchor("center", (e, box-mid))
    } else {
      // Compass anchors on the building: east/west sit at the midpoint
      // of their wall; both walls reach the roof base (valley) height.
      cetz.draw.anchor("south", ((left + right) / 2, ground))
      cetz.draw.anchor("east", (right, (ground + valley) / 2))
      cetz.draw.anchor("west", (left, (ground + valley) / 2))
      cetz.draw.anchor("center", ((left + right) / 2, (ground + valley) / 2))
    }
  }

  symbol("factory", name, ..positions, ..overrides, draw: draw)
}
