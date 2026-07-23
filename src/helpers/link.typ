// Bus-to-bus connector with automatic interior taps and perpendicular
// routing — the "L-bend" the design rules demand, so a conductor can
// never land on a bar's tip.

#import "/src/deps.typ": cetz
#import "/src/symbols/grid/wire.typ": wire
#import "note.typ": note

#let _sub(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
#let _add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let _mul(a, s) = (a.at(0) * s, a.at(1) * s)
#let _dot(a, b) = a.at(0) * b.at(0) + a.at(1) * b.at(1)
#let _len(a) = calc.sqrt(_dot(a, a))
#let _lerp(a, b, t) = (
  a.at(0) + t * (b.at(0) - a.at(0)),
  a.at(1) + t * (b.at(1) - a.at(1)),
)

/// Connect two buses the way the design rules demand: each end taps
/// the bar's *interior* (never a tip) and leaves it *perpendicular*.
/// The route between the taps follows from the bars' geometry:
///
/// - perpendicular bars → an L (one corner);
/// - parallel bars facing each other → a straight perpendicular
///   conductor (the `to:` tap aligns itself with `from:`);
/// - parallel bars offset along their axis → a Z (perpendicular leg,
///   parallel run halfway between the bars, perpendicular leg);
/// - collinear bars (side by side on one line) → a U around them, on
///   the `side:` of the bars, `clearance` past them.
///
/// `label:` captions the route's longest leg via the segment form of
/// `note()` — free side and upright rotation are automatic.
///
/// Both buses must already be drawn (their anchors are resolved when
/// the link draws).
///
/// - a (str): name of the bus the link starts on.
/// - b (str): name of the bus it ends on.
/// - from (float): tap fraction along `a` (0..1). Default `0.5`.
/// - to (float | auto): tap fraction along `b`. `auto` (default) puts
///   the tap opposite `from:` when the bars face each other, else at
///   the bar's centre.
/// - side (str | auto): for the collinear U — which side of the bars
///   the run passes on (`"north"`/`"south"`/`"east"`/`"west"`).
///   `auto` prefers below horizontal bars and east of vertical ones.
/// - clearance (float): perpendicular distance of the U run past the
///   bars. Default `0.5`.
/// - label (content | none): caption for the longest leg.
/// - label-side (str | auto): side the caption sits on (see `note()`).
/// - label-distance (float): caption gap. Default `0.15`.
/// - label-size (length): caption font size. Default `7pt`.
/// - kind (str): `"line"` (default) or `"cable"` — as on `wire()`.
/// - stroke: stroke override, as on `wire()`.
/// -> content
#let link(
  a,
  b,
  from: 0.5,
  to: auto,
  side: auto,
  clearance: 0.5,
  label: none,
  label-side: auto,
  label-distance: 0.15,
  label-size: 7pt,
  kind: "line",
  stroke: auto,
) = {
  assert(
    type(a) == str and type(b) == str,
    message: "link() connects two *named* buses — pass their names",
  )
  cetz.draw.get-ctx(ctx => {
    let (_ctx, a0, a1, b0, b1) = cetz.coordinate.resolve(
      ctx,
      a + ".start",
      a + ".end",
      b + ".start",
      b + ".end",
    )
    let va = _sub(a1, a0)
    let vb = _sub(b1, b0)
    let (la, lb) = (_len(va), _len(vb))
    let u1 = _mul(va, 1 / la)
    let u2 = _mul(vb, 1 / lb)
    let cross = u1.at(0) * u2.at(1) - u1.at(1) * u2.at(0)
    let t1 = _lerp(a0, a1, from)
    let p1 = (-u1.at(1), u1.at(0))

    let pts = if calc.abs(cross) > 0.02 {
      // Non-parallel bars: leave each along its own perpendicular; the
      // corner is where the two perpendicular lines meet.
      let t2 = _lerp(b0, b1, if to == auto { 0.5 } else { to })
      let p2 = (-u2.at(1), u2.at(0))
      let d = _sub(t2, t1)
      let det = -p1.at(0) * p2.at(1) + p2.at(0) * p1.at(1)
      let s = (-d.at(0) * p2.at(1) + p2.at(0) * d.at(1)) / det
      (t1, _add(t1, _mul(p1, s)), t2)
    } else {
      // Parallel bars: `d` is the perpendicular offset between them.
      let d = _dot(_sub(b0, t1), p1)
      let foot = _add(t1, _mul(p1, d))
      let foot-frac = _dot(_sub(foot, b0), u2) / lb
      if (
        to == auto
          and calc.abs(d) > 1e-6
          and foot-frac > 0.1
          and (
            foot-frac < 0.9
          )
      ) {
        // Facing: a single straight perpendicular conductor, landing
        // on b's interior opposite the `from` tap.
        (t1, foot)
      } else {
        let t2 = _lerp(b0, b1, if to == auto { 0.5 } else { to })
        if calc.abs(d) > 1e-6 {
          // Offset bars: Z — perpendicular out to the halfway plane,
          // along it, perpendicular into the other bar.
          let m1 = _add(t1, _mul(p1, d / 2))
          let m2 = _add(t2, _mul(p1, -d / 2))
          (t1, m1, m2, t2)
        } else {
          // Collinear bars: U around them on the chosen side.
          let q = if side == auto {
            // below horizontal bars; east of vertical ones
            if p1.at(1) < -1e-6 { p1 } else if p1.at(1) > 1e-6 {
              _mul(p1, -1)
            } else if p1.at(0) > 0 { p1 } else { _mul(p1, -1) }
          } else {
            let dir = (
              north: (0, 1),
              south: (0, -1),
              east: (1, 0),
              west: (-1, 0),
            ).at(side)
            let along = _dot(p1, dir)
            assert(
              calc.abs(along) > 1e-6,
              message: "link() side " + repr(side) + " is parallel to the bars",
            )
            if along > 0 { p1 } else { _mul(p1, -1) }
          }
          let run = calc.max(_dot(t1, q), _dot(t2, q)) + clearance
          let m1 = _add(t1, _mul(q, run - _dot(t1, q)))
          let m2 = _add(t2, _mul(q, run - _dot(t2, q)))
          (t1, m1, m2, t2)
        }
      }
    }

    wire(..pts, kind: kind, stroke: stroke)

    if label != none {
      // Caption the longest leg; note's segment form supplies the
      // free side and upright rotation.
      let best = (0, none)
      for i in range(pts.len() - 1) {
        let l = _len(_sub(pts.at(i + 1), pts.at(i)))
        if l > best.at(0) { best = (l, i) }
      }
      let i = best.at(1)
      note(
        pts.at(i),
        pts.at(i + 1),
        label,
        side: label-side,
        distance: label-distance,
        size: label-size,
      )
    }
  })
}
