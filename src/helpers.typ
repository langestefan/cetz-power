// Composition helpers — not symbols themselves, just short combinations
// of cetz-power primitives for patterns that would otherwise need the
// caller to write the same loop or coordinate math over and over.

#import "symbols/grid/wire.typ": wire
#import "symbols/grid/bus.typ": bus-frac

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
