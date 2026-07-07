// Miniature vector-group glyphs drawn INSIDE transformer circles —
// the conventional way to state a winding connection on a one-line
// (delta in the HV circle, wye in the LV circle = "Dy…"). Shared by
// `transformer` and `transformer3`; the full-size scaffold symbols
// live in `src/symbols/winding/`.

#import "/src/deps.typ": cetz

#let winding-mark-kinds = ("delta", "wye", "zigzag")

// Draw one glyph of reach `g` centred at `c`. `rot` counter-rotates
// the glyph (pass the negated symbol rotation so marks stay upright,
// like labels). Aliases: "d" = delta, "y"/"star" = wye, "z" = zigzag.
#let winding-mark(c, kind, g, stroke, rot) = {
  let pt(a, rr) = (
    c.at(0) + rr * calc.cos(a + rot),
    c.at(1) + rr * calc.sin(a + rot),
  )
  let k = lower(kind)
  let arms = (90deg, 210deg, 330deg)
  if k in ("delta", "d") {
    cetz.draw.line(
      pt(90deg, g),
      pt(210deg, g),
      pt(330deg, g),
      close: true,
      stroke: stroke,
    )
  } else if k in ("wye", "star", "y") {
    for a in arms { cetz.draw.line(c, pt(a, g), stroke: stroke) }
  } else if k in ("zigzag", "z") {
    // Each arm bends at mid-reach — the zigzag kink.
    for a in arms {
      cetz.draw.line(c, pt(a + 20deg, 0.52 * g), pt(a, g), stroke: stroke)
    }
  } else {
    assert(
      false,
      message: "unknown winding mark "
        + repr(kind)
        + " (expected delta, wye or zigzag)",
    )
  }
}
