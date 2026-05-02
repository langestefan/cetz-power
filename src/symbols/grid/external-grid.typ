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
/// - name (str): CeTZ group name
/// - size (float): square side length
/// - lead (float): length of stub from origin to the bottom of the square
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
  let lead = overrides.at("lead", default: none)
  if lead != none { let _ = overrides.remove("lead") }

  let draw(ctx, positions, style) = {
    let sz = style.at("size", default: 0.5)
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let l = if lead != none { lead } else { style.at("distance", default: 0.2) }
    let bg = style.at("background", default: none)

    let bot = l
    let top = l + sz
    let half = sz / 2

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

    // External-grid hatching. Two main corner-to-corner diagonals are
    // always drawn; line-count adds (n-1) chord pairs in each diagonal
    // direction, evenly spaced at offsets sz/n, 2*sz/n, …, (n-1)*sz/n
    // from the main diagonal. Each chord is a full-width segment with
    // slope ±1, clipped to the square's edges.
    //
    // For n=1 only the X is drawn; for n=2 the result is the classic
    // "rotated inner square surrounded by 4 corner triangles"; for
    // higher n the cross-hatch becomes proportionally denser.
    let n = style.at("line-count", default: 2)
    assert(
      type(n) == int and n >= 0,
      message: "external-grid line-count must be an integer >= 0, got " + repr(n),
    )
    if n >= 1 {
      let step = sz / n
      for i in range(1, n) {
        let k = step * i
        // "\" chords (slope -1, parallel to the top-left → bottom-right diagonal).
        // Upper-right of diagonal: top edge to right edge.
        cetz.draw.line((-half + k, top), (half, bot + k), stroke: s)
        // Lower-left of diagonal: bottom edge to left edge.
        cetz.draw.line((half - k, bot), (-half, top - k), stroke: s)
        // "/" chords (slope +1, parallel to the bottom-left → top-right diagonal).
        // Upper-left of diagonal: left edge to top edge.
        cetz.draw.line((-half, bot + k), (half - k, top), stroke: s)
        // Lower-right of diagonal: bottom edge to right edge.
        cetz.draw.line((-half + k, bot), (half, top - k), stroke: s)
      }
      // Main diagonals — corner to opposite corner.
      cetz.draw.line((-half, top), (half, bot), stroke: s)
      cetz.draw.line((half, top), (-half, bot), stroke: s)
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("in", (0, 0))
    cetz.draw.anchor("center", (0, bot + sz / 2))
    cetz.draw.anchor("north", (0, top))
    cetz.draw.anchor("south", (0, 0))
    cetz.draw.anchor("east", (half, bot + sz / 2))
    cetz.draw.anchor("west", (-half, bot + sz / 2))
  }

  symbol("grid", name, ..positions, ..overrides, draw: draw)
}
