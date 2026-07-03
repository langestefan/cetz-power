// Phase-conductor ticks — the small slanted slashes drawn across a
// conductor to mark its phase/conductor count (three slashes = the
// usual three-phase marking on single-line diagrams).

#import "/src/deps.typ": cetz

/// Draw `count` slanted tick marks across a conductor at `pos`.
///
/// `angle` is the direction of the conductor the ticks sit on
/// (`0deg` horizontal, `-90deg`/`90deg` vertical) — the ticks are
/// spaced along it and slanted across it.
///
/// ```typst
/// wire((0, 0), (3, 0))
/// phase-ticks((0.8, 0))                            // three-phase mark
/// wire((4, 1), (4, -1))
/// phase-ticks((4, 0.4), angle: -90deg)             // on a vertical run
/// phase-ticks(("a.mid", 35%, "b.mid"), count: 4)   // lerp coords work
/// ```
///
/// - pos (coordinate): where on the conductor the tick group sits —
///   any CeTZ coord (anchor, tuple, lerp).
/// - angle (angle): conductor direction. Default `0deg` (horizontal).
/// - count (int): number of ticks. Default `3` (three-phase).
/// - spacing (float): distance between tick centres along the
///   conductor.
/// - length (float): length of each tick stroke.
/// - slant (angle): angle of each tick relative to the conductor.
///   Default `55deg`.
/// - stroke: tick stroke. Default `0.7pt + black`.
/// -> content
#let phase-ticks(
  pos,
  angle: 0deg,
  count: 3,
  spacing: 0.07,
  length: 0.21,
  slant: 55deg,
  stroke: 0.7pt + black,
) = {
  assert(
    type(count) == int and count >= 1,
    message: "phase-ticks count must be an integer >= 1, got " + repr(count),
  )
  let dx = length / 2 * calc.cos(slant)
  let dy = length / 2 * calc.sin(slant)
  cetz.draw.group({
    cetz.draw.set-origin(pos)
    cetz.draw.rotate(angle)
    for i in range(count) {
      let o = (i - (count - 1) / 2) * spacing
      cetz.draw.line((o - dx, -dy), (o + dx, dy), stroke: stroke)
    }
  })
}
