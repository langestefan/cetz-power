// Battery — the IEC cell symbol: a long thin line (positive plate)
// over a short one (negative plate), optionally repeated for a
// multi-cell stack. The single-line-diagram shorthand for BESS units
// and DC auxiliaries.

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// Battery — IEC cell(s). Default form is the symmetric two-pole
/// battery: a lead from `in` up to the bottom (negative, short) plate,
/// `cells` long/short plate pairs, then a matching upper lead ending
/// at `out`. Pass `lead-out: 0` for a single-lead form (no top lead,
/// `out` lands on the top plate).
///
/// Default orientation: `in` at the bottom (negative terminal), `out`
/// at the top (positive terminal); plates lie horizontally. Rotate
/// with `angle:` (`-90deg` lays it horizontal, `in` left).
///
/// Anchors: `in` (= `default`, = `south`, the negative terminal),
/// `out` / `north` (the positive terminal), `east` / `west` (long-
/// plate ends at mid-height), `center`.
///
/// - name (str): CeTZ group name.
/// - pos (coordinate): connection point — the `in` anchor lands here.
/// - cells (int): number of cell pairs. Default `1`; `2` draws the
///   common double-cell form.
/// - long-width (float): width of the long (positive) plate.
/// - short-width (float): width of the short (negative) plate.
/// - gap (float): vertical distance between the plates of one cell.
/// - cell-gap (float): vertical distance between consecutive cells.
/// - lead-in / lead-out (float): lead lengths below / above the stack.
/// - stroke: stroke for leads and plates.
/// - label: standard label dict.
/// - angle (angle): rotation around the connection point.
/// -> content
#let battery(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let lw = style.at("long-width", default: 0.5)
    let sw = style.at("short-width", default: 0.22)
    let gap = style.at("gap", default: 0.12)
    let cgap = style.at("cell-gap", default: 0.18)
    let li = style.at("lead-in", default: 0.3)
    let lo = style.at("lead-out", default: 0.3)
    let cells = style.at("cells", default: 1)
    assert(
      type(cells) == int and cells >= 1,
      message: "battery cells must be an integer >= 1, got " + repr(cells),
    )

    // Geometry along +y: negative (short) plate at the bottom of each
    // cell, positive (long) plate above it.
    let stack-h = cells * gap + (cells - 1) * cgap
    let top-y = li + stack-h
    let out-y = top-y + lo
    let mid-y = li + stack-h / 2

    if li > 0 {
      cetz.draw.line((0, 0), (0, li), stroke: s)
    }
    for i in range(cells) {
      let y0 = li + i * (gap + cgap)
      cetz.draw.line((-sw / 2, y0), (sw / 2, y0), stroke: s)
      cetz.draw.line((-lw / 2, y0 + gap), (lw / 2, y0 + gap), stroke: s)
      // Connect consecutive cells with a short internal lead.
      if i + 1 < cells {
        cetz.draw.line((0, y0 + gap), (0, y0 + gap + cgap), stroke: s)
      }
    }
    if lo > 0 {
      cetz.draw.line((0, top-y), (0, out-y), stroke: s)
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("center", (0, mid-y))
    cetz.draw.anchor("east", (lw / 2, mid-y))
    cetz.draw.anchor("west", (-lw / 2, mid-y))
    // Same convention as the capacitor: `out`/`north` always point at
    // the far end of the body so chained wiring works in both forms.
    let north-y = if lo > 0 { out-y } else { top-y }
    cetz.draw.anchor("out", (0, north-y))
    cetz.draw.anchor("north", (0, north-y))
  }

  symbol("battery", name, ..positions, ..overrides, draw: draw)
}
