// Composition helpers — not symbols themselves, just short combinations
// of cetz-power primitives for patterns that would otherwise need the
// caller to write the same loop or coordinate math over and over.

#import "/src/deps.typ": cetz
#import "symbols/grid/wire.typ": wire
#import "symbols/grid/bus.typ": bus-frac

// Map "the side I want my label to sit on" to "the anchor on the
// label that should land at the supplied position". They're opposites.
// Used by both `note` and `wire(..., label: …)`.
#let _opposite-side = (
  "north":      "south",
  "south":      "north",
  "east":       "west",
  "west":       "east",
  "north-east": "south-west",
  "south-west": "north-east",
  "north-west": "south-east",
  "south-east": "north-west",
)

/// Position a free-floating text label next to a coordinate or anchor.
///
/// `note(pos, body, side: "north")` is shorthand for the manual
/// `cetz.draw.content` call you'd otherwise write to put a caption
/// beside a wire midpoint, an anchor, or a tap point. It picks the
/// content's anchor opposite to `side` and uses `padding` for the gap,
/// so the text always sits cleanly on the requested side of `pos`.
///
/// ```typst
/// note((5, 0), [Hello], side: "north")           // text above (5, 0)
/// note("M1.west", [Motor], side: "west")          // text left of M1
/// note(("a", 50%, "b"), [Kabel], side: "south")   // below the midpoint of a-b
/// ```
///
/// - pos (coordinate): where to anchor the label — anchor name,
///   absolute tuple, lerp `("a", t, "b")`, or any other CeTZ coord.
/// - body (content): the label content.
/// - side (str): which side of `pos` the label sits on. One of
///   `"north"`, `"south"`, `"east"`, `"west"`, `"north-east"`,
///   `"north-west"`, `"south-east"`, `"south-west"`. Default `"north"`.
/// - distance (float): gap (in canvas units) between `pos` and the
///   nearest edge of the text. Default `0.15`.
/// - text-align (alignment | auto): how multi-line text aligns inside
///   its bounding box. `auto` (default) leaves cetz's default; pass
///   `left` / `center` / `right` to override.
/// - size (length): font size. Default `7pt` (matches `#set text(size: 7pt)`
///   in most snippets; bump up for larger captions).
/// -> content
#let note(
  pos,
  body,
  side: "north",
  distance: 0.15,
  text-align: auto,
  size: 7pt,
) = {
  assert(
    side in _opposite-side,
    message: "note() side must be one of " + repr(_opposite-side.keys())
      + ", got " + repr(side),
  )
  let aligned = if text-align == auto { body } else { align(text-align, body) }
  cetz.draw.content(
    pos,
    anchor: _opposite-side.at(side),
    padding: distance,
    text(size: size, aligned),
  )
}

/// Draw `count` parallel wires between two buses.
///
/// Each wire lands at an evenly-spaced fraction on each bar. `from` and
/// `to` let you restrict the vertical (or along-bus) extent on either
/// side — set them to anything but `(0, 1)` to keep the wires away from
/// the bus ends, or to create a fan-out (narrow on one side, wide on
/// the other).
///
/// - source (str): source bus name (e.g. `"b1"`).
/// - target (str): target bus name.
/// - count (int): number of wires (default `3`).
/// - from (array): `(start, end)` fractions on the source bus.
///   Default `(0, 1)` spans the whole bar. `(0.33, 0.67)` hugs the middle
///   third; `(0.2, 0.8)` gives a 60 %-wide bundle.
/// - to (array): same, for the target bus.
/// -> content
#let multi-wire(source, target, count: 3, from: (0, 1), to: (0, 1)) = {
  assert(
    type(count) == int and count >= 1,
    message: "multi-wire count must be a positive integer, got " + repr(count),
  )
  for i in range(count) {
    let t = if count == 1 { 0.5 } else { i / (count - 1) }
    let src-f = from.at(0) + t * (from.at(1) - from.at(0))
    let tgt-f = to.at(0) + t * (to.at(1) - to.at(0))
    wire(bus-frac(source, src-f), bus-frac(target, tgt-f))
  }
}
