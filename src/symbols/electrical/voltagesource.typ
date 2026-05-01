// Voltage source — circuit-theory style. A circle drawn between the
// two connection points with an internal marking that picks the kind
// of source: DC (+/− symbols) or one of the AC waveform variants
// (sine, triangle, sawtooth, square).
//
// Two-node by default — pass `in` and `out` and the symbol centres
// itself between them, drawing leads from each endpoint to the body.
// One-node placement also works for a standalone source.
//
// (For the rotating-machine "V" / "G" / "M" / "A" notation see the
// `machine` symbol under generation/.)

#import "/src/deps.typ": cetz
#import "/src/core.typ": symbol

// Sample a waveform across the interior of a circle of radius `r`.
// Returns a list of (x, y) points the caller can pass to a polyline.
#let _wave(kind, r) = {
  let half-w = r * 0.65
  let amp = r * 0.4
  if kind == "sin" or kind == "ac" {
    let pts = ()
    let n = 32
    for i in range(n + 1) {
      let t = i / n
      let x = -half-w + 2 * half-w * t
      let y = amp * calc.sin(2 * calc.pi * t)
      pts.push((x, y))
    }
    pts
  } else if kind == "tri" {
    (
      (-half-w, 0),
      (-half-w / 2, amp),
      (0, 0),
      (half-w / 2, -amp),
      (half-w, 0),
    )
  } else if kind == "saw" {
    (
      (-half-w, -amp),
      (0, amp),
      (0, -amp),
      (half-w, amp),
    )
  } else if kind == "rect" {
    (
      (-half-w, -amp),
      (-half-w, amp),
      (0, amp),
      (0, -amp),
      (half-w, -amp),
      (half-w, amp),
    )
  } else {
    none
  }
}

/// Voltage source. Two-node: pass `in` and `out` and the symbol sits
/// at the midpoint with the body oriented along the in→out direction.
/// One-node placement also works (no leads are drawn).
///
/// Anchors: `in`, `out` (the two endpoints when two-node placed),
/// `center`, `north`, `south`, `east`, `west`.
///
/// - name (str): CeTZ group name.
/// - radius (float): body-circle radius (style override).
/// - kind (str): one of `"dc"`, `"ac"` (= `"sin"`), `"sin"`, `"tri"`,
///   `"saw"`, `"rect"`. Default `"dc"` draws `+` and `−` markers; the
///   waveform variants draw the corresponding squiggle inside the
///   circle.
/// - stroke / fill: standard style overrides.
/// - label: standard label dict.
/// -> content
#let voltagesource(name, ..args) = {
  let positions = args.pos()
  let overrides = args.named()

  let draw(ctx, positions, style) = {
    let s = style.at("stroke", default: 0.8pt + black)
    let f = style.at("fill", default: none)
    let r = style.at("radius", default: 0.3)
    let kind = style.at("kind", default: "dc")

    let x-left = -r
    let x-right = r

    // Two-node placement: draw leads from each endpoint to the
    // corresponding circle edge when the user-supplied span is wider
    // than the body itself. Same heuristic the transformer uses.
    if positions.len() == 2 {
      let span = cetz.vector.dist(positions.at(0), positions.at(1))
      let half = span / 2
      if half > x-right {
        let wire-stroke = ctx.style
          .at("cetz-power", default: (:))
          .at("wire", default: (:))
          .at("stroke", default: s)
        cetz.draw.line((-half, 0), (x-left, 0), stroke: wire-stroke)
        cetz.draw.line((x-right, 0), (half, 0), stroke: wire-stroke)
      }
    }

    cetz.draw.circle((0, 0), radius: r, stroke: s, fill: f)

    if kind == "dc" {
      // + on the in side, − on the out side. Sized off the radius so
      // the markers stay legible across radius overrides.
      let txt-size = r * 24pt
      cetz.draw.content((-r * 0.45, 0), text(size: txt-size, "+"))
      cetz.draw.content((r * 0.45, 0), text(size: txt-size, "−"))
    } else {
      let pts = _wave(kind, r)
      if pts != none {
        cetz.draw.line(..pts, stroke: s)
      }
    }

    cetz.draw.anchor("default", (0, 0))
    cetz.draw.anchor("center", (0, 0))
    cetz.draw.anchor("north", (0, r + 0.05))
    cetz.draw.anchor("south", (0, -r - 0.05))
    cetz.draw.anchor("east", (r, 0))
    cetz.draw.anchor("west", (-r, 0))
  }

  symbol("voltagesource", name, ..positions, ..overrides, draw: draw)
}
