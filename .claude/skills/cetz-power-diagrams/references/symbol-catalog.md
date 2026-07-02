# Symbol & helper catalog

Every export from `#import "@preview/cetz-power:<v>": *` (or the repo's `/src/lib.typ`).
Defaults below are from `src/styles.typ`. **Placement:** *1-node* = one coordinate, orient
with `angle:`; *2-node* = two coordinates, the symbol centres at the midpoint and orients
in→out, and `angle:` is forbidden. 2-node symbols draw connecting leads from each endpoint
to the body **only when the span is wider than the body** (else the body covers the joints).

All symbols take `stroke`, `fill`, `label` (a dict: `content`, `anchor`, `align`,
`distance`, `size`). The label `anchor:` is a **world-space** compass direction.

## Canvas & connectors
- **`diagram(body, length: 1cm)`** — REQUIRED wrapper (seeds the style dict). `length` =
  cm per unit (the master scale / compression knob). In HTML mode it wraps in `html.frame`.
- **`wire(p1, p2, …)`** — straight segment / polyline. Reads only `cetz-power.wire.stroke`.
  Coords: anchor `"b.mid"`, absolute `(1.5,-0.4)`, relative `(rel:(0.5,0))` or
  `(rel:(0.5,0), to:"b.mid")`. **Not a symbol — no real label**; caption with `note`.
- **`elbow(a, b, corner: "h"|"v")`** — two orthogonal segments with a right-angle knee.
  `"h"` = horizontal then vertical. Also wire-styled, no label.

## grid/
- **`bus(name, p)`** or **`bus(name, p1, p2)`** — busbar. `length` (def 3), `taps` (def 1),
  `angle`. Anchors: `start`, `mid`, `end`, `tap1..tapN`, compass. 1-node uses `length`+`angle`;
  2-node spans the endpoints (length ignored). Stroke 1.8pt (thicker than wires).
- **`bus-frac("b", f)`** — coordinate at fraction `f∈[0,1]` along a bus. Returns
  `("b.start", f*100%, "b.end")` — the `%` matters (a plain float = absolute distance).
- **`junction(name, p)`** — connection point on a conductor. `radius` (0.09), `open` (false =
  filled dot / true = hollow open point, "netopening"), `fill` (`auto` → stroke paint when
  closed, white when open — masks the wire beneath, so draw junctions AFTER wires). Anchors:
  `center` (= in/out) + compass on the circle. 1-node.
- **`external-grid(name, p)`** — infinite-bus hatched box. `size` (0.9), `width`/`height`
  (`none`→`size`; set either for a rectangle — hatch stays true 45°), `lead`/`distance`
  (0.2), `line-count` (2; 0=plain,1=bare X), `background`. Anchors: `in`/`default`, `center`,
  compass (`east`/`west` = side mids). 1-node, box hangs below the origin.
- **`transformer(name, in, out)`** — two-winding (two overlapping circles). `radius` (0.45),
  `distance` (0.35, centre-to-centre), `primary-stroke`/`secondary-stroke` (+ fills) for
  per-winding colour. Anchors: `in`/`primary`, `out`/`secondary`, `center`, compass.
  **2-node only.** Leads drawn when span > `2*radius + distance`.
- **`transformer3(name, p)`** — three-winding trefoil. `radius` (0.32), `distance` (0.42),
  `lead` (0; stub to terminal), `hv-angle`/`lv-angle`/`tv-angle` (180/60/−60°). Anchors:
  `hv`/`primary`, `lv`/`secondary`, `tv`/`tertiary`, `center`, compass. **1-node**; rotate
  with `angle:`.

## generation/
- **`machine(name, p[, letter])`** — circle with an optional centre letter/content
  (`"G"`/`"M"`/`"V"`/`"A"` or math). `radius` (0.3), `letter-size` (10pt). Anchors: all 8
  compass points **on the circle** (safe wire endpoints) + `center`. 1-node.
- **`pv-panel(name, p)`** — panel box + chevron. `size` (0.35 width), `aspect` (1.6 h/w),
  `lead` (0.25), `elbow` (L-route), `triangle-fill`/`triangle-height`. Anchors: `in`/`north`,
  `south`, `center`, `east`/`west`. 1-node, hangs below.

## loads/
- **`load(name, p)`** — filled down-arrow. `size` (0.28), `lead` (0.25), `elbow` (L-route:
  across `elbow`, then down `lead`), `fill` (black; `none`=hollow). Aim with `angle:`
  (down default · 180=up · 90=right · 270=left). Anchors: `in`/`north` (root), `tip`/`south`,
  `east`/`west`, `label-east`/`label-west`. 1-node. **Anchor at the bus it taps (root).**

## electrical/  (all 1-node along +y; pass `lead-out: 0` for the single-pole/shunt form)
- **`capacitor(name, p)`** — two plates. `plate-width` (0.5), `plate-gap` (0.12),
  `lead-in`/`lead-out` (0.3), `plate-stroke`. Anchors `in`/`south`, `out`/`north`, `center`.
- **`resistor(name, p)`** — IEC rectangle. `width` (0.3), `length` (0.7), leads (0.2).
- **`inductor(name, p)`** — IEEE bumps. `bumps` (4), `bump-radius` (0.1), leads (0.2).
- **`diode(name, p)`** — triangle + cathode bar (anode=`in`→cathode=`out`). `width`/`height`
  (0.4), `fill` (none; black=filled), leads (0.15).
- **`voltagesource(name, in[, out])`** — circle, `kind`: `"dc"` (+/−) · `"ac"`/`"sin"` ·
  `"tri"` · `"saw"` · `"rect"`. `radius` (0.3). Anchors: compass **on circle**, `center`.
  1- or 2-node (2-node draws leads). *A sine generator is `voltagesource(p, kind:"sin")`.*
- **`currentsource(name, in[, out])`** — circle with in→out arrow; `kind:"ac"` adds a sine.
  `radius` (0.3). Compass anchors sit slightly **off** the circle.
- **`ground(name, p)`** — `kind`: `"earth"` (def) · `"chassis"` · `"signal"`. `lead` (0.18),
  `width` (0.4). Anchors `in`/`north`, `south`, `center`. 1-node, hangs below.
- **`bolt(name, in, out)`** — lightning zigzag for faults/surges. `segments` (4),
  `amplitude` (0.12), `arrow` (true), `arrow-color`. Anchor `center`. **2-node only.**

## protection/  (all **2-node**, sit inline on a wire)
- **`switch(name, in, out)`** — disconnector. `closed` (false=open, tilted bar),
  `switch-length` (0.45), `open-angle` (30°; negative flips the blade to the other side),
  `pivot-radius` (0.045; pass 0 to omit the pin dots — bare netopening blade). Anchors
  `center`,`north`,`south`. Open-blade lean is auto from context; SLD convention is OPEN.
  Set switch-length = exact span to avoid leftover stub slivers at the endpoints.
- **`breaker(name, in, out)`** — square on the wire. `size` (0.3). Compass anchors. `kind:
  "cross"` draws the network-overview × instead (wire runs through, no gap); breaker also
  accepts a SINGLE position (+ `angle:`) to drop the marker onto an existing run.
- **`fuse(name, in, out)`** — rectangle with wire through it. `length` (0.6), `width` (0.22).

## winding/  (vector-group primitives; **1-node**; rotate with `angle:` — `−clock*30deg` for IEC clock)
- **`delta(name, p)`** / **`wye(name, p)`** / **`zigzag(name, p)`** — `size` (0.6, centre→terminal),
  `terminals` (`("U","V","W")`; lowercase for secondary), `body` (true; `false` = anchors-only
  scaffold, no geometry/labels). Anchors: `u`/`v`/`w`, side/arm midpoints (`mid-uv…` for delta,
  `mid-u…` for wye/zigzag), `neutral` (wye/zigzag centre), compass, + each string terminal name.
  zigzag adds `zigzag-kink` (0.5) and `zigzag-offset` (0.18).

## helpers/
- **`note(pos, body, side: "north", distance: 0.15)`** — floating label; sits on `side` of
  `pos` (picks the opposite text anchor). Works with any coord (anchor/absolute/lerp). Use it
  to caption wires and tap points.
- **`multi-wire(source, target, count:, from:, to:)`** — fan `count` wires off bus `source`.
  `target` = **bus name** (str) → bus-to-bus bundle (`to` applies); = **`(dx,dy)`** (array)
  → free stubs of that offset. `from`/`to` are `(start,end)` fraction pairs on each bar.
  `count: 1` = single coupler at band midpoint. Land on a band-overshooting bar with
  `from: (over/L, 1-over/L)`.
- **`feeder(name, start, stations, …)`** — distribution run: spine + evenly-spaced taps +
  per-tap transformer/load drop + per-segment `currents:` labels + dashed `extend:` tail.
  `stations` = list of `(label:, load:)` dicts (omit `load` = bare tap). Key sizing:
  `lead`, `spacing`, `tail`, `drop`, `drop-angle`, `up: true` (drop upward). Names parts
  `<name>-t<i>` / `<name>-l<i>`.
- **`dali(name, pos, …)`** — CT clamp (I) + voltage transformer (V) + labelled box below a
  line. `width` (I↔V tap distance), `lead`/`tail`, `box-width`/`box-height`,
  `tx-radius`/`tx-distance`/`tx-stroke`/`tx-fill`, `clamp-radius`. Names `<name>` (box),
  `<name>-ct` (clamp), `<name>-vt` (transformer); draws no I/V captions — anchor your own
  `note`s. The measured line is drawn by the caller and passes through the clamp.

## Custom symbols (when nothing fits)
Wrap `symbol()` from `/src/core.typ`:
```typst
#import "/src/core.typ": symbol
#let junction(name, pos, ..o) = {
  let draw(ctx, positions, style) = {
    let r = style.at("radius", default: 0.06)
    cetz.draw.circle((0,0), radius: r, fill: black)
    cetz.draw.anchor("north", (0, r)); cetz.draw.anchor("south", (0, -r))   // …etc
  }
  symbol("junction", name, pos, ..o, draw: draw)   // 1-node
}
// two-node: pass (a, b); `symbol` rotates the closure so local +x points in→out.
// length = cetz.vector.dist(positions.first(), positions.last())
```
The wrapper auto-exposes `in`/`out`, resolves style, places labels in world frame, and
moves the pen to the last position. Add a `styles.typ` family sub-dict for new style keys.
