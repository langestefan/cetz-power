// Fan of parallel wires off a bus — to a facing bus or as free stubs.

#import "/src/deps.typ": cetz
#import "/src/symbols/grid/wire.typ": wire
#import "/src/symbols/grid/bus.typ": bus-frac

/// Draw `count` parallel wires off a bus — either to a second bus, or as
/// free stubs into open space.
///
/// Each wire starts at an evenly-spaced fraction on the source bar. `from`
/// and `to` restrict the along-bus extent on either side — set them to
/// anything but `(0, 1)` to keep the wires away from the bus ends, or to
/// create a fan-out (narrow on one side, wide on the other).
///
/// `target` is polymorphic:
/// - a **bus name** (str) → each wire lands at the matching fraction on
///   that bar (the classic bus-to-bus bundle); `to` applies.
/// - an **offset** `(dx, dy)` (array of two numbers) → each wire is a stub
///   of that displacement from its source point, so a bundle can terminate
///   in open space (departing feeders, taps with no facing bar). `to` is
///   ignored.
///
/// - source (str): source bus name (e.g. `"b1"`).
/// - target (str | array): target bus name, or a `(dx, dy)` stub offset.
/// - count (int): number of wires (default `3`).
/// - from (array): `(start, end)` fractions on the source bus.
///   Default `(0, 1)` spans the whole bar. `(0.33, 0.67)` hugs the middle
///   third; `(0.2, 0.8)` gives a 60 %-wide bundle.
/// - to (array): same, for the target bus (bus-name target only).
/// -> content
#let multi-wire(source, target, count: 3, from: (0, 1), to: (0, 1)) = {
  assert(
    type(count) == int and count >= 1,
    message: "multi-wire count must be a positive integer, got " + repr(count),
  )
  // A string target is a facing bus; anything else is a `(dx, dy)` stub
  // offset applied to each source point.
  let stub = type(target) != str
  for i in range(count) {
    let t = if count == 1 { 0.5 } else { i / (count - 1) }
    let src-f = from.at(0) + t * (from.at(1) - from.at(0))
    let a = bus-frac(source, src-f)
    let b = if stub {
      (rel: (target.at(0), target.at(1)), to: a)
    } else {
      bus-frac(target, to.at(0) + t * (to.at(1) - to.at(0)))
    }
    wire(a, b)
  }
}
