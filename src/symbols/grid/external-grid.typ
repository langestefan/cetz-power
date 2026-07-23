// External grid (infinite bus) — single-terminal connection to "the grid".
//
// Drawn as a cross-hatched square — visual shorthand for "we don't
// model anything beyond this point — assume an infinite source".

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// External grid / infinite-bus connection.
///
/// Drawn as a square with diagonal hatching inside. The two main
/// diagonals (corner-to-corner) are always drawn; `line-count`
/// controls how many additional chord pairs are added on top of
/// them, giving a denser cross-hatch:
///
/// - `line-count: 0` — bare square, no hatching at all.
/// - `line-count: 1` — just the two main diagonals (a bare X
///   inside the square).
/// - `line-count: 2` — default: 1 chord in each of 4 directions
///   added to the diagonals (the conventional "rotated inner square
///   surrounded by 4 triangles" hatching).
/// - `line-count: 3`, `4`, … — progressively denser hatching.
///
/// Pass it as a per-call override or globally via `set-style`.
///
/// The symbol is a square by default. Pass `width` and/or `height` to
/// draw it as a rectangle — the cross-hatching stretches to the new
/// aspect ratio. Either one defaults to `size` when omitted, so setting
/// just `width` gives a wide box of height `size`, and so on.
///
/// - name (str): CeTZ group name
/// - size (float): square side length (default for both width and height)
/// - width (float): box width; defaults to `size`
/// - height (float): box height; defaults to `size`
/// - lead (float): length of stub from origin to the bottom of the box
/// - line-count (int): hatching density. Default `2`.
/// - background (color | none): fill colour for the inside of the
///   square, drawn under the cross-hatching so the chord lines
///   remain visible on top. Default `none`. Read `background` as
///   "the colour behind the hatching" — it's the same shape as
///   `fill` but the name reads more naturally for that intent.
/// -> content
#let external-grid(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()
  // `lead` is the canonical name; `distance` is accepted per-call as a
  // legacy alias (the key was renamed) — pop both so neither leaks into
  // the merged style, where the family `lead` default would shadow a
  // per-call `distance`.
  let lead = overrides.at(
    "lead",
    default: overrides.at("distance", default: none),
  )
  if "lead" in overrides { let _ = overrides.remove("lead") }
  if "distance" in overrides { let _ = overrides.remove("distance") }

  let draw(ctx, positions, style) = {
    let sz = style.at("size", default: 0.5)
    // Width and height default to the square `size`; set either (or both)
    // to draw a rectangular external grid. The hatching below is written
    // in terms of edge fractions, so it stretches to any aspect ratio and
    // reduces exactly to the classic square pattern when `sw == sh`.
    let sw = style.at("width", default: none)
    let sh = style.at("height", default: none)
    if sw == none { sw = sz }
    if sh == none { sh = sz }
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let l = if lead != none { lead } else {
      // `lead` is the canonical style key; `distance` kept as a fallback
      // for style dicts written before the rename.
      style.at("lead", default: style.at("distance", default: 0.2))
    }
    let bg = style.at("background", default: none)

    let bot = l
    let top = l + sh
    let half = sw / 2

    // Stub
    if l > 0 {
      cetz.draw.line((0, 0), (0, bot), stroke: s)
    }
    // Backdrop fill — drawn before the square outline and the chord
    // lines, bounded to the square interior, so the hatching reads as
    // sitting ON TOP of the colour. `fill` (the conventional shape
    // fill) is then layered on top, allowing both to coexist if
    // somebody passes both.
    if bg != none {
      cetz.draw.rect((-half, bot), (half, top), fill: bg, stroke: none)
    }
    // Outer square
    cetz.draw.rect((-half, bot), (half, top), stroke: s, fill: f)

    // External-grid hatching: a family of true ±45° lines (slope ±1),
    // evenly spaced and *clipped to the box edges* — so the diagonals stay
    // at 45° whatever the aspect ratio (a wide box is not a stretched X,
    // it's a straight-line cross-hatch). `line-count` sets the density:
    // the spacing is (shorter side)/n, so a square keeps the conventional
    // look — n=1 is the bare X, n=2 the classic "rotated inner diamond
    // surrounded by 4 corner triangles", higher n a denser hatch — and a
    // rectangle is filled with the same-pitch 45° grid.
    let n = style.at("line-count", default: 2)
    assert(
      type(n) == int and n >= 0,
      message: "external-grid line-count must be an integer >= 0, got "
        + repr(n),
    )
    if n >= 1 {
      let xL = -half
      let xR = half
      let yB = bot
      let yT = top
      let d = calc.min(sw, sh) / n // 45° line pitch (along an axis)
      // Number of evenly-spaced offsets across the box's diagonal span,
      // excluding the two zero-length corner grazes at the extremes.
      let steps = int(calc.floor((sw + sh) / d + 0.000001))
      let eps = 0.000000001
      for i in range(1, steps) {
        let off = i * d
        // "\" line (slope −1): x + y = c, clipped to the box.
        let c = (xL + yB) + off
        let lo = calc.max(xL, c - yT)
        let hi = calc.min(xR, c - yB)
        if hi - lo > eps {
          cetz.draw.line((lo, c - lo), (hi, c - hi), stroke: s)
        }
        // "/" line (slope +1): y − x = g, clipped to the box.
        let g = (yB - xR) + off
        let glo = calc.max(xL, yB - g)
        let ghi = calc.min(xR, yT - g)
        if ghi - glo > eps {
          cetz.draw.line((glo, g + glo), (ghi, g + ghi), stroke: s)
        }
      }
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("center", (0, bot + sh / 2))
    cetz.draw.anchor("north", (0, top))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("east", (half, bot + sh / 2))
    cetz.draw.anchor("west", (-half, bot + sh / 2))
  }

  symbol("grid", name, ..positions, ..overrides, draw: draw)
}
