# Design rules for clean single-line diagrams

These are the conventions that separate a sloppy diagram from a publication-quality
one. They were learned by iterating a real figure (a modified IEEE-9 + MV/DVPP grid)
against detailed human review. Apply them **from the start** — retrofitting is painful.

## 1. Always open with `diagram`

`diagram({ ... })` (or `diagram(length: 1cm, { ... })`) seeds the style dictionary.
Raw `cetz.canvas` leaves every symbol on hard-coded literal defaults. `length:` sets
the cm-per-unit scale and is the main compression knob (see rule 13).

## 2. Connections tap a bus *interior*, never an outer edge

Every conductor, elbow, load and branch must meet a busbar **along its body**, comfortably
inside `[a,b]` — **never at an extreme tip/outer edge**: not the left/right end of a
horizontal bar, and not the top/bottom of a *vertical* tick-bus. A drop hanging off the
very end reads as broken/dangling. Tap a little in — `bus-frac("b", 0.15..0.85)` or an
explicit interior coordinate — and let the bar **extend a little past** its outermost taps
(a small overshoot beyond the connections is the clean busbar look). Labels *at* the ends
are fine; connections are not.

**Make node/tick buses big enough that "interior" is visibly distinct from the tip.** If a
bus is so short that a body-tap and an edge-tap look the same, the bus is too small —
lengthen it. A row of single-point nodes drawn as tiny ticks is a common offender: model
each as a real (taller) vertical busbar so the feeder can tap its centre and the loads/
risers its body, with the bar overshooting both.

## 3. Prefer the bus *centre* for a single perpendicular drop

When one line drops onto a bus, land it on the centre (`"b.mid"`, or the midpoint x/y).
A drop hitting a bus off-centre for no reason looks arbitrary. The exception is when a
bus carries several taps (rule 6) — then distribute them, don't stack them all centre.

## 4. Lines join a bus **perpendicularly** — never at an angle

A conductor must meet a busbar at 90° (vertical into a horizontal bar, horizontal into
a vertical bar). For a run that must move sideways (a "funnel" of two buses converging
on a third), do **not** draw a single diagonal into the bus. Instead:

```
small perpendicular stub  →  diagonal  →  small perpendicular stub (equal length)
```

e.g. leave the upper bus straight down by `d`, run the diagonal, then drop straight into
the lower bus by the same `d`. Both joins are then perpendicular:

```typst
// 4→5 leg: down d, diagonal, down d into bus 4
wire(P(343,104), P(343,116)); wire(P(343,116), P(352,147)); wire(P(352,147), P(352,159))
```

## 5. Collinear shared verticals

When two conductors leave the *same* bus on opposite sides (one up to bus A, one down to
bus B), give them **one shared x** so they read as a single straight line through the
bar — not two near-parallel stubs 1–2 px apart. Same for a load hanging below a tap that
a line enters from above: put both on the bus centre/that tap's x.

## 6. Distribute taps evenly; balance margins

A busbar's taps should be **equidistant from its edges** and from each other — not
bunched to one side. For a 3-connection bus use the canonical layout: a **centre tap**
plus two **equidistant side taps** (e.g. transformer→left, the bus-above link→centre,
the load→right). If the connection x-positions are fixed by alignment to other buses,
**resize the bar** so its edges sit symmetrically around them (equal left/right margin)
rather than moving the connections. Bus length is free — it is length-defined.

## 7. Mirror real symmetry

Where the source figure is symmetric (two feeders funnelling into one bus, a balanced
H-configuration), make it *exactly* symmetric about the relevant axis. Reflect each
vertex through the axis (`mirror_x = 2*axis − x`) so the two halves are pixel-mirrors,
and put the axis on a real feature (the centre-tap load). Shift a bus left/right until
its connection mirrors its partner, rather than eyeballing.

## 8. Loads: small, correctly aimed, rooted at the bus

- Keep them **small** — `size ≈ 0.16–0.2`, `lead ≈ 0.13–0.16`. Oversized arrows dominate.
- Aim with `angle:` (one-node rotation): default = down; `180deg` = up; `90deg` = right;
  `270deg` = left. Verify direction in the render — don't assume the sign.
- For an "up-then-right" (or any elbow) load, combine `angle:` with `elbow:` — e.g.
  `load(p, angle: 90deg, elbow: 0.18)` leaves the bus, goes up `elbow`, then right `lead`,
  arrowhead right.
- **On a vertical bus, a down-load must leave the body *perpendicular* — an L-bend across
  (right) then down — never straight off the bottom tip.** Use `load(p, elbow: e)`: it goes
  across `e`, then down `lead`, arrowhead down. Tap the point `p` on the bus *interior*
  (rule 2), not its end. This is the same perpendicular-join principle as rule 4: a line
  meeting a vertical bar leaves it horizontally first.
- A node bus carrying **several drops** (a load *and* a branch) gives **each its own
  interior tap** — e.g. the feeder taps the centre and two more taps sit on the lower body,
  spread apart (rule 6), each leaving with its own L-bend. Don't stack them on one point or
  hang them off the tip. **Order the taps so their leads don't cross**: put the far-reaching
  branch on the *upper* body tap and the short load on the *lower* one, so the load's
  down-segment stays *below* the branch's horizontal run (a short load on the upper tap
  would have its arrow cut straight across the branch).
- **Anchor at the arrow root (the bus it taps), not the far tip.** A long arrow's tip can
  sit nearer the next bus and mis-read.

## 9. Use the built-in symbols — don't hand-draw

If a glyph exists, use it. A synchronous machine drawn as a circle-with-sine is
`voltagesource(name, p, kind: "sin", fill: gray)`; a lettered machine (`G`/`M`/`V`/`A`)
is `machine(name, p, "G")`. Re-drawing a sine by hand is a smell. The library already
has switches, breakers, fuses, windings, PV panels, grounds — reach for them.

## 10. No floating blocks — connect every device

A coloured device block (wind / BESS / PV / a custom box) must be wired to its
transformer/bus with a real conductor stub. A box sitting near a transformer with a gap
between them reads as floating. Add the short `wire(box-edge, transformer-endpoint)`.

## 11. Keep symbols clear of an area box; let *leads* cross it

When a dashed "area" rectangle (a DVPP/plant boundary) groups part of the network, its
edge may be crossed by **leads** (thin conductors entering the area) but must **not**
slice through a **symbol** (a transformer's circles, a machine, a box). Size/position the
box so its border falls in the gap between the boundary symbols and the first inside bus.
After compressing (rule 13) re-check this — fixed-size symbols grow *relative* to the
shrunk layout and can newly intersect the box.

## 12. Nothing overlaps: text, boxes, annotations

- Place a label on the side **away** from the bus's connections (`note(..., side: ...)`,
  or the label `anchor:` — remember it is a **world-space** compass direction).
- Put a machine/source caption **outside** its circle (offset by `radius + gap`), not on it.
- Don't duplicate a label the figure/diagram already carries.
- After every change, zoom the dense clusters and confirm no glyph touches another.

## 13. Compress by scaling the layout, not the symbols

"Lines too long" ⇒ shorten the gaps. With a pixel-mapped layout (`P(x,y) = (x*s, …)`),
**reduce `s`**: every conductor run and inter-bus gap shrinks, while absolute-sized
symbols (transformer radius, machine radius, load size, box size, text pt) stay put — so
lines get shorter *relative to* the symbols (less whitespace). Then:

- Shrink the **largest** absolute symbols a little (SG circles, transformer radius) so
  they stay proportional to the now-shorter buses and don't crowd.
- Re-run the overlap and area-box checks (rules 11–12) — compression is where collisions
  appear. Keep text readable: if labels start colliding you've compressed too far for the
  current font; either stop or drop the font a point.

## 14. Symmetric overshoot when aligning bus tops/ends

To line a tall bus's top up with a shorter reference bar, compute the overshoot once and
apply it to **both** ends: `over = ref_h/2 − gap/2`, place from `(x, top + over)` to
`(x, bottom − over)`. Extending only one end leaves the bar visually lopsided.

## 15. Wires can't be labelled

`wire`/`elbow` skip the symbol/label machinery. To caption a conductor, attach a `note`
to one of its endpoints, or label the symbol on either end. Don't try `wire(..., label:)`.

## 16. Equal spacing between repeated elements

Uniformity reads as *organised*; irregular gaps read as sloppy, even when nothing is
technically wrong. Whenever elements repeat, give them **equal distances** rather than
eyeballed ones:

- **Repeated components / nodes** on a run (a row of node buses, a bank of feeders, a
  line of loads) should sit at a **constant pitch**. Drive them from a loop with a single
  `spacing`/`pitch` constant, not hand-placed x's.
- **Repeated branch shapes** should share their lengths. If several branches leave a
  feeder and turn (up to a riser, down to a sub-feeder), give each the **same horizontal
  run before it turns** — one `dbr` constant, `rx = tap_x + dbr` — so every elbow lines up
  instead of wandering (this is what fixed the MV-radial-feeder risers). The same goes for
  equal lead lengths, equal drop depths, equal stub lengths.
- This generalises rule 6 (even taps *on one bus*) to the **whole drawing**: equal
  gaps between buses, equal margins around a group, equal offsets for parallel conductors.

When a distance is arbitrary, make it a **named constant reused everywhere** — that both
guarantees equality and makes later compression (rule 13) a one-line change.

---

## The authoring loop

1. **Plan the skeleton** — list buses (orientation, rough position), then the conductors
   between them, then the transformers/machines/loads. Sketch the grid of rows/columns.
2. **Lay out coordinates.** Either design clean cm coordinates directly, or — when
   replicating a figure — digitise from a reference image with a pixel map (see
   `replicating-figures.md`).
3. **Draw in dependency order:** area boxes first (behind), then buses, then
   transformers, then machines + stubs, then conductors, then loads, then captions.
4. **Compile and zoom.** `typst compile --root . file.typ out.png --ppi 200`, then crop
   and view the dense regions. The metric is your eyes: every join perpendicular and
   interior, taps balanced, no overlaps, devices connected.
5. **Iterate rule-by-rule.** Fix one class of issue at a time (all the perpendicular
   joins, then all the tap balancing, …) and re-render.
