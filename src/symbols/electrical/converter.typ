// Power-electronic converter — the IEC box-with-diagonal symbol: a
// square split by a diagonal, with a waveform glyph in each triangle
// naming the port kind. `kind: "ac-dc"` (rectifier), `"dc-ac"`
// (inverter), `"ac-ac"` and `"dc-dc"` cover the four conversion modes;
// the first token is the `in`-side glyph (upper-left triangle), the
// second the `out`-side glyph (lower-right triangle).

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

// Draw one port glyph centred on `c`, scaled off the box size `sz`.
// "ac" is a one-period sine; "dc" is the IEC mark — a solid line over
// a dashed one (the dashes drawn as segments so they scale cleanly).
#let _port-glyph(tok, c, sz, s) = {
  let (cx, cy) = c
  if tok == "ac" {
    let w = sz * 0.38
    let amp = sz * 0.075
    let pts = ()
    let n = 24
    for i in range(n + 1) {
      let t = i / n
      pts.push((cx - w / 2 + w * t, cy + amp * calc.sin(2 * calc.pi * t)))
    }
    cetz.draw.line(..pts, stroke: s)
  } else {
    // "dc"
    let w = sz * 0.32
    let gap = sz * 0.10
    cetz.draw.line(
      (cx - w / 2, cy + gap / 2),
      (cx + w / 2, cy + gap / 2),
      stroke: s,
    )
    // Dashed lower line: three dashes with equal gaps (w/5 pitch).
    let d = w / 5
    for i in (0, 2, 4) {
      cetz.draw.line(
        (cx - w / 2 + i * d, cy - gap / 2),
        (cx - w / 2 + (i + 1) * d, cy - gap / 2),
        stroke: s,
      )
    }
  }
}

/// Power-electronic converter (rectifier / inverter / AC or DC
/// coupler). Two-node: pass `in` and `out` and the body sits at the
/// midpoint with leads to the two endpoints, oriented along in→out.
/// One-node: pass a single position (plus optional `angle:`) to place
/// the box on its centre — wire it up via the compass anchors.
///
/// Anchors: `in`, `out` (the two endpoints), `center`, `north`,
/// `south`, `east`, `west` (edge midpoints of the box).
///
/// - name (str): CeTZ group name.
/// - pos-in, pos-out (coordinates): the two endpoints (or one point).
/// - kind (str): `"<in>-<out>"` with each token `"ac"` or `"dc"` —
///   `"ac-dc"` (default), `"dc-ac"`, `"ac-ac"`, `"dc-dc"`. The first
///   token is drawn in the upper-left triangle (the `in` side).
/// - size (float): side length of the square box.
/// - stroke: box, diagonal and glyph stroke.
/// - fill: box fill (default `none`).
/// - label: standard label dict (default anchor `"south"`).
/// -> content
#let converter(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let sz = style.at("size", default: 0.7)
    let kind = style.at("kind", default: "ac-dc")

    if positions.len() > 2 {
      assert(false, message: "converter() takes one or two positions")
    }

    let ports = kind.split("-")
    assert(
      ports.len() == 2 and ports.all(p => p in ("ac", "dc")),
      message: "converter kind must be \"<in>-<out>\" with tokens "
        + "\"ac\" or \"dc\" (e.g. \"ac-dc\", \"dc-ac\"), got "
        + repr(kind),
    )

    let half-sz = sz / 2
    let span = if positions.len() == 2 {
      cetz.vector.dist(positions.at(0), positions.at(1))
    } else { 0 }
    let half = span / 2

    // Two-node placement: leads from the endpoints to the box edges,
    // drawn in wire style (same heuristic as breaker / transformer).
    if half > half-sz {
      let wire-stroke = ctx
        .style
        .at("cetz-power", default: (:))
        .at("wire", default: (:))
        .at("stroke", default: s)
      cetz.draw.line((-half, 0), (-half-sz, 0), stroke: wire-stroke)
      cetz.draw.line((half-sz, 0), (half, 0), stroke: wire-stroke)
    }

    cetz.draw.rect(
      (-half-sz, -half-sz),
      (half-sz, half-sz),
      stroke: s,
      fill: f,
    )
    // Diagonal from the lower-left to the upper-right corner: the
    // upper-left triangle belongs to the `in` port, the lower-right
    // to the `out` port.
    cetz.draw.line((-half-sz, -half-sz), (half-sz, half-sz), stroke: s)

    _port-glyph(ports.at(0), (-sz * 0.22, sz * 0.22), sz, s)
    _port-glyph(ports.at(1), (sz * 0.22, -sz * 0.22), sz, s)

    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, half-sz))
    cetz.draw.anchor("south", (0, -half-sz))
    cetz.draw.anchor("east", (half-sz, 0))
    cetz.draw.anchor("west", (-half-sz, 0))
  }

  symbol("converter", name, ..positions, ..overrides, draw: draw)
}
