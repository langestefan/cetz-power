// Generation plant — wind / PV / BESS pictograms, alone or side by side
// in one enclosure. `kind:` names the technology mix ("wind", "pv-bess",
// "wind-pv-bess", …; concatenated forms like "windpvbess" also parse) and
// `variant:` numbers the enclosure, so the catalog reads wind-1, pv-2,
// windpvbess-1, … :
//
//   1 — enclosure with one compartment per technology (default)
//   2 — plain enclosure, icons in a row
//   3 — bare icons, no enclosure
//   4 — composite: all technologies overlapping in a single square
//       (turbine left, panel at its foot, upright battery behind)
//   5 — composite, mirrored arrangement (turbine right, panel top-left,
//       battery bottom-left)
//
// Each technology token can carry its own icon-style number ("pv2",
// "wind2", …) for alternative pictograms (variants 1–3; the composite
// variants use fixed arrangements):
//
//   wind1 — single three-blade turbine        wind2 — park (two turbines)
//   wind3 — park (small, large, medium — the large one spans the box)
//   pv1   — outline panel with cell grid      pv2   — filled panel, white grid
//   pv3   — park (two overlapping panels)
//   bess1 — IEC battery plates                bess2 — charged-battery outline
//
// One-node: box centred on the position (wire via compass anchors).
// Two-node: body at the midpoint with leads to the endpoints, oriented
// along in→out (same convention as `block`).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

#let _plant-kinds = ("wind", "pv", "bess")
#let _plant-icon-styles = (wind: (1, 2, 3), pv: (1, 2, 3), bess: (1, 2))
#let _digits = "0123456789"

// "pv2" → (tech: "pv", style: 2); bare "pv" → style 1.
#let _split-token(tok, kind) = {
  let tech = none
  for t in _plant-kinds {
    if tok.starts-with(t) {
      tech = t
      break
    }
  }
  assert(
    tech != none,
    message: "plant(): unknown technology "
      + repr(tok)
      + " in kind "
      + repr(kind)
      + " (expected wind, pv, bess, optionally numbered like \"pv2\")",
  )
  let rest = tok.slice(tech.len())
  assert(
    rest.clusters().all(c => c in _digits),
    message: "plant(): cannot parse token "
      + repr(tok)
      + " in kind "
      + repr(kind),
  )
  let style = if rest == "" { 1 } else { int(rest) }
  assert(
    style in _plant-icon-styles.at(tech),
    message: "plant(): "
      + tech
      + " has icon styles "
      + repr(_plant-icon-styles.at(tech))
      + ", got "
      + str(style),
  )
  (tech: tech, style: style)
}

// "wind-pv2-bess" → ((tech: "wind", style: 1), (tech: "pv", style: 2), …).
// Accepts hyphenated or concatenated spellings; the icon order follows
// the token order.
#let _parse-kind(kind) = {
  let k = lower(kind).replace(" ", "").replace("_", "-")
  let toks = ()
  if k.contains("-") {
    toks = k.split("-").map(t => _split-token(t, kind))
  } else {
    let rest = k
    while rest.len() > 0 {
      let hit = none
      for t in _plant-kinds {
        if rest.starts-with(t) {
          hit = t
          break
        }
      }
      assert(
        hit != none,
        message: "plant(): cannot parse kind " + repr(kind),
      )
      rest = rest.slice(hit.len())
      let num = ""
      while rest.len() > 0 and rest.slice(0, 1) in _digits {
        num += rest.slice(0, 1)
        rest = rest.slice(1)
      }
      toks.push(_split-token(hit + num, kind))
    }
  }
  assert(
    toks.len() in (1, 2, 3),
    message: "plant(): kind must name 1 to 3 technologies",
  )
  assert(
    toks.map(t => t.tech).dedup().len() == toks.len(),
    message: "plant(): kind " + repr(kind) + " repeats a technology",
  )
  toks
}

// ── Pictogram primitives ─────────────────────────────────────────────
// Cell icons are drawn inside a square of side `s` centred at (cx, 0);
// the parametric primitives below also serve the composite variants.

// One three-blade turbine: mast bottom at (x, base), total height h.
#let _turbine(x, base, h, stroke, fill) = {
  let hub = (x, base + 0.65 * h)
  cetz.draw.line((x, base), hub, stroke: stroke)
  for a in (90deg, 210deg, 330deg) {
    cetz.draw.line(
      hub,
      (x + 0.35 * h * calc.cos(a), base + 0.65 * h + 0.35 * h * calc.sin(a)),
      stroke: stroke,
    )
  }
  cetz.draw.circle(hub, radius: 0.05 * h, stroke: none, fill: fill)
}

// Tilted panel (sheared parallelogram) with a 3 x 2 cell grid, centred
// at (cx, cy), side `s`. `body-fill` paints the panel; `grid-stroke`
// draws the cell lines (white on a filled panel).
#let _panel(cx, cy, s, stroke, body-fill, grid-stroke) = {
  let sh = 0.11 * s // half the horizontal shear between top and bottom edge
  let ew = 0.36 * s // half edge width
  let hh = 0.36 * s // half height
  let bl = (cx + sh - ew, cy - hh)
  let br = (cx + sh + ew, cy - hh)
  let tl = (cx - sh - ew, cy + hh)
  let tr = (cx - sh + ew, cy + hh)
  let lerp(a, b, f) = (
    a.at(0) * (1 - f) + b.at(0) * f,
    a.at(1) * (1 - f) + b.at(1) * f,
  )
  cetz.draw.line(bl, br, tr, tl, close: true, stroke: stroke, fill: body-fill)
  for f in (1 / 3, 2 / 3) {
    cetz.draw.line(lerp(bl, br, f), lerp(tl, tr, f), stroke: grid-stroke)
  }
  cetz.draw.line(lerp(bl, tl, 0.5), lerp(br, tr, 0.5), stroke: grid-stroke)
}

// Charged-battery outline centred at (cx, cy): body, terminal nub, two
// filled bars. `w` is the total extent along the battery axis (nub
// included), `h` across it; `vertical: true` stands it upright.
#let _battery(cx, cy, w, h, stroke, fill, vertical: false) = {
  let nub = 0.12 * w
  let bar = 0.22 * w // filled-bar width along the axis
  let gap = 0.08 * w
  let inset = 0.09 * w
  let a0 = cx - 0.5 * w // axis start (left / bottom)
  if not vertical {
    cetz.draw.rect(
      (a0, cy - 0.5 * h),
      (a0 + w - nub, cy + 0.5 * h),
      stroke: stroke,
    )
    cetz.draw.rect(
      (a0 + w - nub, cy - 0.2 * h),
      (a0 + w, cy + 0.2 * h),
      stroke: stroke,
      fill: fill,
    )
    for i in (0, 1) {
      let x = a0 + inset + i * (bar + gap)
      cetz.draw.rect(
        (x, cy - 0.32 * h),
        (x + bar, cy + 0.32 * h),
        stroke: none,
        fill: fill,
      )
    }
  } else {
    let b0 = cy - 0.5 * w
    cetz.draw.rect(
      (cx - 0.5 * h, b0),
      (cx + 0.5 * h, b0 + w - nub),
      stroke: stroke,
    )
    cetz.draw.rect(
      (cx - 0.2 * h, b0 + w - nub),
      (cx + 0.2 * h, b0 + w),
      stroke: stroke,
      fill: fill,
    )
    for i in (0, 1) {
      let y = b0 + inset + i * (bar + gap)
      cetz.draw.rect(
        (cx - 0.32 * h, y),
        (cx + 0.32 * h, y + bar),
        stroke: none,
        fill: fill,
      )
    }
  }
}

// ── Cell icons (variants 1–3) ────────────────────────────────────────

// `full` is the full cell extent — wind3's large turbine spans it.
#let _icon-wind(cx, s, full, style, stroke, fill) = {
  if style == 1 {
    _turbine(cx, -0.5 * s, s, stroke, fill)
  } else if style == 2 {
    // Park: full-size turbine in front, smaller one behind to the right.
    _turbine(cx - 0.16 * s, -0.5 * s, 0.95 * s, stroke, fill)
    _turbine(cx + 0.28 * s, -0.5 * s, 0.62 * s, stroke, fill)
  } else {
    // Larger park: small left, medium right, and a large turbine in the
    // centre spanning the box height (minus a tiny gap at the top).
    // Overlap is intentional.
    let b = -0.48 * full
    _turbine(cx - 0.33 * full, b, 0.42 * full, stroke, fill)
    _turbine(cx + 0.31 * full, b, 0.62 * full, stroke, fill)
    _turbine(cx, b, 0.92 * full, stroke, fill)
  }
}

#let _icon-pv(cx, s, style, st, fill, mask-fill) = {
  let thickness = stroke(st).thickness
  if thickness == auto { thickness = 0.8pt }
  if style == 1 {
    _panel(cx, 0, s, st, none, st)
  } else if style == 2 {
    // Dark cells, white grid lines.
    _panel(cx, 0, s, st, fill, thickness + white)
  } else {
    // Park: smaller panel behind, masked full panel in front.
    _panel(cx + 0.22 * s, 0.14 * s, 0.72 * s, st, none, st)
    _panel(cx - 0.12 * s, -0.1 * s, 0.85 * s, st, mask-fill, st)
  }
}

#let _icon-bess(cx, s, style, stroke, fill) = {
  if style == 1 {
    // IEC cell: long (positive) plate, short (negative) plate, leads.
    cetz.draw.line(
      (cx - 0.09 * s, -0.30 * s),
      (cx - 0.09 * s, 0.30 * s),
      stroke: stroke,
    )
    cetz.draw.line(
      (cx + 0.09 * s, -0.14 * s),
      (cx + 0.09 * s, 0.14 * s),
      stroke: stroke,
    )
    cetz.draw.line((cx - 0.45 * s, 0), (cx - 0.09 * s, 0), stroke: stroke)
    cetz.draw.line((cx + 0.09 * s, 0), (cx + 0.45 * s, 0), stroke: stroke)
  } else {
    _battery(cx, 0, 0.85 * s, 0.48 * s, stroke, fill)
  }
}

// ── Composite variants (4 / 5): everything in one square ────────────
// `c` is the square side. The pictograms overlap deliberately — the
// goal is a well-filled square, not separated icons. Panels are drawn
// last with a masking fill so they sit visually in front.
#let _composite(techs, variant, c, st, fill, mask) = {
  let w = "wind" in techs
  let p = "pv" in techs
  let b = "bess" in techs
  let n = techs.len()

  if n == 1 {
    // Single technology: one large pictogram filling the square.
    if w { _turbine(0, -0.47 * c, 0.94 * c, st, fill) }
    if p { _panel(0, 0, 0.95 * c, st, none, st) }
    if b { _battery(0, 0, 0.8 * c, 0.45 * c, st, fill) }
  } else if variant == 4 {
    // Turbine left (full height), upright battery right (behind),
    // panel at the turbine's foot (in front).
    if w and b {
      _battery(0.3 * c, 0.0 * c, 0.58 * c, 0.26 * c, st, fill, vertical: true)
    }
    if b and not w {
      _battery(0.28 * c, 0.04 * c, 0.62 * c, 0.3 * c, st, fill, vertical: true)
    }
    if w { _turbine(-0.2 * c, -0.47 * c, 0.94 * c, st, fill) }
    if p and w and b { _panel(0.02 * c, -0.27 * c, 0.55 * c, st, mask, st) }
    if p and w and not b { _panel(0.16 * c, -0.26 * c, 0.62 * c, st, mask, st) }
    if p and b and not w { _panel(-0.1 * c, -0.2 * c, 0.68 * c, st, mask, st) }
  } else {
    // Mirrored: turbine right (full height), panel top-left, battery
    // bottom-left (lying flat).
    if w { _turbine(0.2 * c, -0.47 * c, 0.94 * c, st, fill) }
    if b and w { _battery(-0.19 * c, -0.33 * c, 0.5 * c, 0.26 * c, st, fill) }
    if b and not w {
      _battery(0.16 * c, -0.3 * c, 0.55 * c, 0.28 * c, st, fill)
    }
    if p and w { _panel(-0.22 * c, 0.16 * c, 0.5 * c, st, mask, st) }
    if p and not w { _panel(-0.14 * c, 0.14 * c, 0.6 * c, st, mask, st) }
  }
}

/// Generation plant (wind / PV / BESS, in any combination).
///
/// Anchors: `in`, `out`, `center`, compass edges and corners (of the
/// enclosure, or the icon row's bounding box for the bare variant), plus
/// one south-edge anchor per technology cell named after its token
/// (`wind`, `pv`, `bess` — without the icon-style number) — handy for
/// hanging notes or extra leads.
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): one position (centred) or two
///   (inline with leads, oriented along in→out).
/// - kind (str): technology mix, e.g. `"wind"`, `"pv-bess"`,
///   `"wind-pv-bess"` (or concatenated: `"windpvbess"`). Icon order
///   follows the token order. A token may carry an icon-style number:
///   `wind2` / `wind3` (park, two / three turbines), `pv2` (filled
///   panel), `pv3` (panel park), `bess2` (charged-battery outline).
/// - variant (int): 1 = compartment box, 2 = plain box, 3 = bare icons,
///   4 / 5 = single-square composites (overlapping arrangements).
/// - cell (float): width of one technology cell (and the composite square).
/// - height (float): enclosure height.
/// - icon-scale (float): icon size as a fraction of the cell (variants 1–3).
/// - stroke: enclosure outline. icon-stroke / icon-fill (default `auto`)
///   follow it unless overridden.
/// - fill: enclosure fill.
/// - label: standard label dict (default anchor `"south"`).
/// -> content
#let plant(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let toks = _parse-kind(style.at("kind", default: "wind"))
    let variant = style.at("variant", default: 1)
    assert(
      variant in (1, 2, 3, 4, 5),
      message: "plant(): variant must be 1..5, got " + repr(variant),
    )

    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let cell = style.at("cell", default: 0.7)
    let h = style.at("height", default: 0.7)
    let icon-scale = style.at("icon-scale", default: 0.85)

    let icon-stroke = style.at("icon-stroke", default: auto)
    if icon-stroke == auto { icon-stroke = s }
    let icon-fill = style.at("icon-fill", default: auto)
    if icon-fill == auto {
      icon-fill = if type(s) == color { s } else { stroke(s).paint }
      if icon-fill == auto { icon-fill = black }
    }
    // Paint used to mask pictograms drawn "in front" (PV-park front
    // panel, composite panels): match the enclosure fill so the overlap
    // reads as depth, not as a hole.
    let mask-fill = if f != none { f } else { white }

    let composite = variant >= 4
    let n = toks.len()
    let hw = if composite { cell / 2 } else { n * cell / 2 }
    let hh = h / 2

    if positions.len() > 2 {
      assert(false, message: "plant() takes one or two positions")
    }

    // Two-node placement: leads from the endpoints to the body edges,
    // drawn in wire style (same heuristic as block / breaker).
    let span = if positions.len() == 2 {
      cetz.vector.dist(positions.at(0), positions.at(1))
    } else { 0 }
    let half = span / 2
    if half > hw {
      let wire-stroke = ctx
        .style
        .at("cetz-power", default: (:))
        .at("wire", default: (:))
        .at("stroke", default: s)
      cetz.draw.line((-half, 0), (-hw, 0), stroke: wire-stroke)
      cetz.draw.line((hw, 0), (half, 0), stroke: wire-stroke)
    }

    if variant != 3 {
      cetz.draw.rect((-hw, -hh), (hw, hh), stroke: s, fill: f)
    }
    if variant == 1 {
      for i in range(1, n) {
        let x = -hw + i * cell
        cetz.draw.line((x, -hh), (x, hh), stroke: s)
      }
    }

    if composite {
      _composite(
        toks.map(t => t.tech),
        variant,
        calc.min(cell, h),
        icon-stroke,
        icon-fill,
        mask-fill,
      )
    } else {
      let isize = calc.min(cell, h) * icon-scale
      for (i, tok) in toks.enumerate() {
        let cx = -hw + (i + 0.5) * cell
        if tok.tech == "wind" {
          _icon-wind(
            cx,
            isize,
            calc.min(cell, h),
            tok.style,
            icon-stroke,
            icon-fill,
          )
        }
        if tok.tech == "pv" {
          _icon-pv(cx, isize, tok.style, icon-stroke, icon-fill, mask-fill)
        }
        if tok.tech == "bess" {
          _icon-bess(cx, isize, tok.style, icon-stroke, icon-fill)
        }
      }
    }

    // Per-technology anchors along the south edge (evenly spread for
    // the composite square, one per cell otherwise).
    for (i, tok) in toks.enumerate() {
      let cx = -hw + (i + 0.5) * (2 * hw / n)
      cetz.draw.anchor(tok.tech, (cx, -hh))
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

  symbol("plant", name, ..positions, ..overrides, draw: draw)
}
