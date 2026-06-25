// DALI-style metering unit: a CT clamp around the line, a voltage
// transformer on a tap wire, and a labelled box below.

#import "/src/deps.typ": cetz
#import "/src/symbols/grid/transformer.typ": transformer
#import "note.typ": note

/// Draw a DALI metering unit hanging from a line — a current clamp (CT)
/// *around the measured line* for I, a voltage transformer (the
/// `transformer` symbol) on a tap wire for V, and a labelled box below. It
/// reproduces the metering tap at an LV interface (see the reactive-flow
/// recipe); relabel it with `label:` for any similar CT + VT metering box.
///
/// `pos` is the point on the line the unit hangs from — the top centre,
/// midway between the I and V taps — so place it on a horizontal line. The
/// vertical layout is `line → lead → V transformer → tail → box`; the CT
/// clamp encircles the line at the I tap (the line, drawn by the caller,
/// passes straight through it), and its secondary drops to the box.
///
/// - name (str): names the box (`<name>`), the current clamp (`<name>-ct`)
///   and the voltage transformer (`<name>-vt`). Anchor to them to add your
///   own captions, e.g. `note("<name>-ct.west", [I])`.
/// - pos (coordinate): tap point on the line (top centre, between I and V).
/// - width (float): horizontal distance between the I and V taps.
/// - lead (float): vertical distance from the line down to the symbols.
/// - tail (float): vertical distance from the symbols down to the box.
/// - box-width (float | auto): box width (`auto` = `width + 0.6`).
/// - box-height (float): box height.
/// - clamp-radius (float): CT-clamp circle radius (it encircles the line).
/// - tx-radius / tx-distance / tx-stroke / tx-fill: passed straight to the
///   `transformer` used for V, so it configures like any transformer.
///   `tx-stroke: auto` (default) follows `stroke`.
/// - label (content): box label. Default `[DALI]`.
/// - stroke: stroke for the wires, clamp and box.
/// - fill: box fill (default `none`).
/// -> content
///
/// I / V captions are intentionally left out — anchor to `<name>-ct` (the
/// clamp) and `<name>-vt` (the transformer) and place your own `note`s.
#let dali(
  name,
  pos,
  width: 0.9,
  lead: 0.35,
  tail: 0.4,
  box-width: auto,
  box-height: 0.7,
  clamp-radius: 0.14,
  tx-radius: 0.16,
  tx-distance: 0.18,
  tx-stroke: auto,
  tx-fill: none,
  label: [DALI],
  stroke: 0.8pt + black,
  fill: none,
) = {
  let hw = width / 2
  let p(dx, dy) = (rel: (dx, dy), to: pos)
  let vt-body = tx-distance + 2 * tx-radius     // VT in→out span
  let drop = lead + vt-body + tail              // line → box top
  let bw = if box-width == auto { width + 0.6 } else { box-width }
  let ts = if tx-stroke == auto { stroke } else { tx-stroke }

  // I — a CT clamp encircling the measured line at the tap; its secondary
  // drops to the box. The line itself is drawn by the caller.
  cetz.draw.circle(p(-hw, 0), radius: clamp-radius, stroke: stroke, fill: none,
    name: name + "-ct")
  cetz.draw.line(p(-hw, -clamp-radius), p(-hw, -drop), stroke: stroke)

  // V — tap wire, the voltage transformer (reused `transformer` symbol,
  // spanning exactly its body so it draws no extra leads), then on to the box.
  cetz.draw.line(p(hw, 0), p(hw, -lead), stroke: stroke)
  transformer(name + "-vt", p(hw, -lead), p(hw, -(lead + vt-body)),
    radius: tx-radius, distance: tx-distance, stroke: ts, fill: tx-fill)
  cetz.draw.line(p(hw, -(lead + vt-body)), p(hw, -drop), stroke: stroke)

  // The box (named, so callers can anchor to it).
  cetz.draw.rect(p(-bw / 2, -drop), p(bw / 2, -drop - box-height),
    stroke: stroke, fill: fill, name: name)
  cetz.draw.content(p(0, -drop - box-height / 2), label)
}
