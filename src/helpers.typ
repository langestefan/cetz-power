// Composition helpers — not symbols themselves, just short combinations
// of cetz-power primitives for patterns that would otherwise need the
// caller to write the same loop or coordinate math over and over.

#import "/src/deps.typ": cetz
#import "symbols/grid/wire.typ": wire
#import "symbols/grid/bus.typ": bus-frac
#import "symbols/grid/transformer.typ": transformer
#import "symbols/loads/load.typ": load

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

/// Draw a feeder: a straight run with an evenly-spaced tap per station,
/// each optionally carrying a transformer + load "drop", plus per-segment
/// current labels and a dashed continuation. Both feeders of a radial /
/// distribution diagram come from the same call with different data.
///
/// The run is horizontal, starting at `start` and going +x. Station `i`
/// is tapped at `start + (lead + i·spacing, 0)`; the drop hangs below
/// (or above, with `up: true`).
///
/// - name (str): base name; the i-th station's transformer / load get
///   `<name>-t<i>` / `<name>-l<i>` group names.
/// - start (coordinate): where the run begins (any CeTZ coordinate).
/// - stations (array): one dict per station. Recognised keys:
///     - `label` (content | none): caption beside the tap (e.g. station
///       id + voltage), placed opposite the drop.
///     - `load` (content | none): caption under the load arrow (e.g. the
///       LV rating). When present a transformer + load drop is drawn;
///       when absent / `none` the station is a bare labelled tap.
///     - `tx` (bool): per-station override of the feeder `tx` flag — set
///       `false` to hang the load straight off the tap (no transformer).
///     - `stroke` / `fill`: per-station load-arrow styling (thin / thick /
///       coloured), overriding the feeder `load-stroke` / `load-fill`.
///     - `tx-stroke` / `tx-fill`: per-station transformer styling,
///       overriding the feeder `tx-stroke` / `tx-fill`.
/// - currents (array): segment labels, one per segment — there are
///   `stations.len() + 1` segments (the lead-in, each inter-station gap,
///   and the tail). `none` entries are skipped (e.g. when the first
///   segment is labelled elsewhere).
/// - lead (float): distance from `start` to the first station.
/// - spacing (float): distance between consecutive stations.
/// - tail (float | auto): distance from the last station to the line end.
///   `auto` (default) uses `lead`.
/// - extend (float): dashed continuation drawn past the end (`0` = none).
/// - line-stroke (stroke | auto): stroke of the main run. `auto` (default)
///   uses the active `cetz-power.wire.stroke` — pass e.g. `1.4pt + blue`
///   for a heavier or colour-coded feeder line.
/// - extend-stroke (stroke): stroke of the dashed continuation. Defaults to
///   `(dash: "dashed")`; set it to match a custom `line-stroke`.
/// - drop (float): length of the transformer + load drop.
/// - up (bool): drop above the run instead of below (current labels and
///   the station caption flip sides to match).
/// - dot (float): tap-dot radius (`0` = no dot).
/// - label-gap / load-gap (float): tap-to-caption distances.
/// - tx (bool): draw a transformer in each drop (`false` = load only).
/// - tx-radius / tx-distance (float): drop transformer geometry.
/// - tx-stroke / tx-fill: default transformer styling for the feeder
///   (per-station `tx-stroke` / `tx-fill` override these).
/// - load-size / load-lead (float): drop load-arrow geometry.
/// - load-stroke / load-fill: default load-arrow styling for the feeder
///   (per-station `stroke` / `fill` override these).
/// -> content
#let feeder(
  name,
  start,
  stations,
  currents: (),
  lead: 1.7,
  spacing: 2.5,
  tail: auto,
  extend: 0.6,
  line-stroke: auto,
  extend-stroke: (dash: "dashed"),
  drop: 0.95,
  up: false,
  dot: 0.06,
  label-gap: 0.5,
  load-gap: 1.7,
  tx: true,
  tx-radius: 0.2,
  tx-distance: 0.22,
  tx-stroke: 0.8pt + black,
  tx-fill: none,
  load-size: 0.26,
  load-lead: 0.12,
  load-stroke: 0.8pt + black,
  load-fill: black,
) = {
  let n = stations.len()
  let dir = if up { 1 } else { -1 }                 // drop direction (±y)
  let tail-len = if tail == auto { lead } else { tail }
  let total = lead + calc.max(n - 1, 0) * spacing + tail-len

  // The run + optional dashed continuation. `line-stroke: auto` falls back
  // to the active `cetz-power.wire.stroke`.
  wire(start, (rel: (total, 0), to: start), stroke: line-stroke)
  if extend > 0 {
    wire((rel: (total, 0), to: start), (rel: (total + extend, 0), to: start),
      stroke: extend-stroke)
  }

  // Stations: tap dot, caption, and (when a `load` is given) the drop.
  for (i, st) in stations.enumerate() {
    let tap = (rel: (lead + i * spacing, 0), to: start)
    if dot > 0 { cetz.draw.circle(tap, radius: dot, fill: black) }
    let label = st.at("label", default: none)
    if label != none {
      cetz.draw.content((rel: (0, -dir * label-gap), to: tap), align(center)[#label])
    }
    let load-label = st.at("load", default: none)
    if load-label != none {
      let ang = if up { 180deg } else { 0deg }
      // Per-station overrides: `tx` toggles the transformer, `stroke` /
      // `fill` restyle the load arrow and `tx-stroke` / `tx-fill` the
      // transformer (thin / thick / coloured).
      let st-tx = st.at("tx", default: tx)
      let st-stroke = st.at("stroke", default: load-stroke)
      let st-fill = st.at("fill", default: load-fill)
      let st-tx-stroke = st.at("tx-stroke", default: tx-stroke)
      let st-tx-fill = st.at("tx-fill", default: tx-fill)
      if st-tx {
        // Tap → transformer → load.
        let foot = (rel: (0, dir * drop), to: tap)
        transformer(name + "-t" + str(i), tap, foot,
          radius: tx-radius, distance: tx-distance,
          stroke: st-tx-stroke, fill: st-tx-fill)
        load(name + "-l" + str(i), foot, lead: load-lead, size: load-size,
          angle: ang, stroke: st-stroke, fill: st-fill)
      } else {
        // No transformer: the load hangs straight off the tap (its lead
        // spans the drop).
        load(name + "-l" + str(i), tap, lead: drop, size: load-size,
          angle: ang, stroke: st-stroke, fill: st-fill)
      }
      cetz.draw.content((rel: (0, dir * load-gap), to: tap), align(center)[#load-label])
    }
  }

  // Per-segment current labels, sitting opposite the drops.
  let side = if up { "south" } else { "north" }
  for (i, c) in currents.enumerate() {
    if c != none {
      let mx = if i == 0 {
        lead / 2
      } else if i < n {
        lead + (i - 0.5) * spacing
      } else {
        lead + calc.max(n - 1, 0) * spacing + tail-len / 2
      }
      note((rel: (mx, 0), to: start), c, side: side)
    }
  }
}
