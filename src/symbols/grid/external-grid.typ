// External grid (infinite bus) — single-terminal connection to "the grid".
//
// Drawn as a cross-hatched square — visual shorthand for "we don't
// model anything beyond this point — assume an infinite source".

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

/// External grid / infinite-bus connection.
///
/// Drawn as a square with an X inside (cross-hatching can be added with
/// more lines if desired — default keeps it clean).
///
/// - name (str): CeTZ group name
/// - size (float): square side length
/// - lead (float): length of stub from origin to the bottom of the square
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

    let bot = l
    let top = l + sz
    let half = sz / 2

    // Stub
    if l > 0 {
      cetz.draw.line((0, 0), (0, bot), stroke: s)
    }
    // Outer square
    cetz.draw.rect((-half, bot), (half, top), stroke: s, fill: f)

    // External-grid hatching: n-1 parallel chords in each of the two
    // diagonal directions, stopping at the square's sides to form the
    // familiar "cross-hatched square" (rotated inner square surrounded by
    // four triangles when n=2).
    let n = style.at("line-count", default: 2)
    let step = sz / n
    for i in range(1, n) {
      let o = step * i
      // "\" chords: short lines parallel to the top-left → bottom-right diagonal.
      cetz.draw.line((-half + o, top), (-half, top - o), stroke: s)
      cetz.draw.line((half - o, bot), (half, bot + o), stroke: s)
      // "/" chords: short lines parallel to the top-right → bottom-left diagonal.
      cetz.draw.line((-half + o, top), (half, top - o), stroke: s)
      cetz.draw.line((half - o, bot), (-half, bot + o), stroke: s)
    }
    // Main diagonals — corner to opposite corner.
    cetz.draw.line((-half, top), (half, bot), stroke: s)
    cetz.draw.line((half, top), (-half, bot), stroke: s)

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
