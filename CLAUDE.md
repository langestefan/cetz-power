# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`cetz-power` is a Typst package that draws power-system single-line diagrams. It is a thin wrapper around [CeTZ](https://github.com/cetz-package/cetz) `0.4.2` (pinned in `src/deps.typ`). Package metadata lives in `typst.toml`; the entry point is `src/lib.typ`, which re-exports the canvas wrapper, every symbol in `src/symbols/`, and the composition helpers in `src/helpers/`.

## Common commands

- Run the whole test suite: `./tests/run.sh`
- Run a single suite (or a few): `./tests/run.sh bus wire transformer` — argument is the directory name under `tests/`.
- Compiler selection: the script first tries `$COMPILER` (default `../tsc.js`, a node wrapper expected one level above the repo root) and falls back to the system `typst` CLI. To force the CLI: `COMPILER=/dev/null ./tests/run.sh` (or just install `typst` and remove the wrapper).
- Each test compiles `tests/<name>/test.typ` → `tests/<name>/out/test.svg`. There is no automatic image-diff step; failure means "did not compile". `tests/<name>/ref/` images, if added, are for manual comparison only.
- Build the docs locally: `cd docs && npm ci && npm run dev`. Live preview at `http://localhost:4321/cetz-power/`. `npm run build` produces a static site under `docs/dist/`.
- The docs are an [Astro Starlight](https://starlight.astro.build) site. Prose lives in MDX under `docs/src/content/docs/`; Typst diagrams live as standalone snippets under `docs/snippets/<category>/<name>.typ` (category sub-folders mirroring `src/symbols/`, plus `recipes/`, `helpers/`, `getting-started/`, `extending/`) and are compiled to SVG by `docs/scripts/build-diagrams.mjs` (which walks the tree) into a **flat** `docs/public/diagrams/<name>.svg`. Snippet basenames are unique across folders, so the `<Snippet name="..." />` component (in `docs/src/components/Snippet.astro`) resolves a snippet by basename regardless of which folder it lives in — `name` never includes the sub-path.
- The deployed docs are built and pushed to GitHub Pages by `.github/workflows/docs.yml` on every push to `main`. CI runs Node 22 (Astro 6 requires Node ≥22.12); local dev needs the same.

## Architecture

### Symbol families

`src/symbols/` is organised into seven category sub-directories that mirror the docs sidebar:

- `src/symbols/grid/` — network infrastructure (`bus`, `wire`, `external-grid`, `transformer`, `transformer3`, `junction`). `junction` is a connection point on a conductor: filled circle = closed, `open: true` = hollow open point (netopening) whose body masks the wire beneath — draw junctions after wires. `transformer` is a two-node element that orients along its in→out line; `transformer3` (three-winding trefoil) has three terminals, so it is a one-node symbol placed with `angle:` and exposes `hv`/`lv`/`tv` (= `primary`/`secondary`/`tertiary`) terminal anchors. `ct`/`vt` are the instrument transformers: `ct` is a circle ON a conductor (primary straight through, secondary taps a compass anchor), `vt` a small two-winding pair hanging below a tap point. `autotransformer` is the IEC single-circle-with-loop form; both it and `transformer` accept `oltc: true` for the tap-changer arrow. `transformer` and `transformer3` accept `vector:` — in-circle winding marks (`"delta"`/`"wye"`/`"zigzag"` per circle, e.g. `("delta", "wye")` for Dy); the circle spacing auto-widens so the marks clear the outlines, and they stay upright under rotation (via `ctx.rotation`); glyphs live in `winding-mark.typ`.
- `src/symbols/generation/` — sources (`machine`, `pv-panel`, `block`, `plant`). `block` is the generic labelled device box (wind/BESS/PV/controller): `body:` content centred inside, `fill:` for colour-coding, compass + corner anchors; one-node centred or two-node inline with leads. `plant` is the pictogram box for renewable plants: `kind:` mixes 1–3 of `wind`/`pv`/`bess` (hyphenated or concatenated; a token may carry an icon-style number — `wind2`/`wind3` park with two/three turbines, `pv2` filled panel, `pv3` panel park, `bess2` charged-battery outline) and `variant:` numbers the rendering (1 compartments, 2 plain box, 3 bare icons, 4/5 single-square composites with overlapping pictograms), so catalog names like `windpvbess-1` map onto `kind` + `variant`; placement and anchors follow `block`, plus one south-edge anchor per technology.
- `src/symbols/loads/` — energy consumers (`load`, `factory`). `factory` is the industrial-consumer building pictogram (sawtooth roof with `teeth:` teeth, a steam pipe standing on the roof-base ledge, `windows:` window dashes, optional `smoke: true` wisps) enclosed in a `plant`/`block`-style device box by default (`box: false` for the bare building); the lead lands on the box top (bare: pipe top) and follows `load`'s lead/`elbow:` conventions.
- `src/symbols/electrical/` — passive components, sources, ground, power electronics, and the lightning `bolt` (`capacitor`, `resistor`, `inductor`, `diode`, `voltagesource`, `currentsource`, `converter`, `battery`, `ground`, `bolt`). `converter` is the IEC box-with-diagonal power-electronic converter; `kind: "<in>-<out>"` with `ac`/`dc` tokens covers ac-dc, dc-ac, ac-ac and dc-dc.
- `src/symbols/protection/` — switchgear and overcurrent/overvoltage protection (`switch`, `breaker`, `fuse`, `arrester`, `relay`). `arrester` is the IEC surge arrester (box with a filled arrow toward the earthed side); two-node, arrow points in→out, so terminate `out` on a `ground()` for the shunt form. `switch(earthing: true)` is the earthing switch — the earth-electrode mark drawn at `out`. `breaker` draws a square box (default) or, with `kind: "cross"`, the compact × network-overview mark; it accepts one position (marker on an existing wire) or two (inline with leads), and `body:` centres content in the square (`[R]` recloser, `[S]` sectionalizer — cetz `content` text stays upright under rotation on its own). `relay` is the protection function box (ANSI device number / IEC code, `kind: "box"` rectangle or `"circle"`); wire its trip command to a breaker with a dashed line + `flow-arrow` head.
- `src/symbols/control/` — block-diagram junctions for control schemes (`adder` = circle with inscribed +, the summing point; `mixer` = circle with inscribed ×, the multiplication point). One-node, compass anchors on the circle; `fill: white` masks a conductor beneath. Input signs are `note()`s, not part of the symbol.
- `src/symbols/winding/` — transformer vector-group windings (`delta`, `wye`, `zigzag`). These expose phase-terminal anchors (`u`/`v`/`w`, side midpoints) and respect a `terminals` style key for labels; pass `body: false` to keep just the anchors as a placement scaffold.

Adding a new symbol means picking the right category, dropping the file there, exporting it from `src/lib.typ` (which has a section per category), and adding a default style sub-dict under the symbol's family name in `src/styles.typ`.

### One primitive, many symbols

Every symbol under `src/symbols/<category>/<name>.typ` is a thin closure around `symbol()` in `src/core.typ`. `symbol(family, name, ..positions, draw: <closure>, label:, angle:)` does the heavy lifting:

1. **Style resolution** via `utils.typ::resolve-style`: merges flat top-level `cetz-power.*` keys, then the `cetz-power.<family>` sub-dict, then per-call named arguments. Defaults live in `src/styles.typ`.
2. **Coordinate resolution and placement**: one position → symbol drawn in its local frame at that point with optional `angle:`; two positions → symbol centered at the midpoint and rotated so its local +x axis points from `in` to `out`. Two-node placement forbids `angle:` (asserted).
3. **Anchors**: `in` and `out` are always exposed (they alias the origin for one-node symbols, the two endpoints for two-node). Each symbol's `draw` closure adds further named anchors (`north`/`south`/etc., plus symbol-specific names like `primary`, `secondary`, `hv`, `lv`, `tv`).
4. **Labels** are drawn *outside* the rotated CeTZ group (in world frame) so text stays upright regardless of symbol rotation. The `anchor:` in the label dict is a **world-space** compass direction; `core.typ` rotates it back through `-effective-angle` to find the matching local anchor on the symbol.
5. After drawing, the CeTZ "pen" is moved to the last input position so chained `line((), (rel: ...))` calls behave naturally.

When adding a new symbol, follow the existing pattern: drop the file under the appropriate `src/symbols/<category>/` sub-directory, do `#import "/src/core.typ": symbol`, build a `draw(ctx, positions, style)` closure that emits CeTZ primitives in local space and registers anchors, then call `symbol(<family>, name, ..positions, ..overrides, draw: draw)`. Add a default sub-dict under the family name in `styles.typ` if you need new style keys, and re-export from the matching block in `src/lib.typ`.

### Buses are length-defined, not symbol-sized

`bus()` is special: it has a `length` (or two endpoints), and exposes `start`, `mid`, `end`, plus N evenly-spaced `tap1..tapN` anchors when called with `taps: N`. Use `bus-frac("b1", 0.25)` to address a fractional point — it returns a CeTZ lerp coordinate `(b1.start, 25%, b1.end)` evaluated lazily. **The `25%` matters:** CeTZ reads a plain-float lerp offset as an *absolute distance* along the segment, only a ratio as a true fraction — so `bus-frac` multiplies its argument by `100%`. (Same for `multi-wire`'s `from`/`to`, which are fractions.)

**Aligning bus tops/ends — do this with equal overshoots, every time.** When a tall bus must line its *top* up with a shorter reference bar (e.g. the OS-MS/RS-MS bars vs. the TS bar in the MS-transport recipe, or the MS bar vs. the HS bar in feeder-compensation), do **not** just stretch the top. Compute the overshoot once and apply it symmetrically to *both* ends: `over = ref-h/2 - gap/2`, then place the tall bus from `(x, top-cable + over)` to `(x, bottom-cable - over)`. Extending only the top leaves the bar visually lopsided and misaligned — this keeps coming up, so reach for the symmetric-overshoot pattern from the start.

### Wires are not symbols

`wire()` and `elbow()` in `src/symbols/wire.typ` skip the `symbol()` machinery entirely (no label, no family-style cascade). They only read `cetz-power.wire.stroke` from the active style and draw a `cetz.draw.line`. Both take `kind: "cable"` to re-dash the resolved stroke (pattern from `cetz-power.wire.cable-dash`) so underground cables read differently from overhead lines. Don't try to give them labels — wrap a labelled box around them instead, or attach the label to the symbol on either end.

### Composition helpers

`src/helpers/` (one file per helper, mirroring `src/symbols/`) is for short combinations of existing primitives that would otherwise force the caller to write the same loop or coordinate math repeatedly — it is **not** for new symbols. `src/lib.typ` re-exports each helper. It currently exports eight things:

- `multi-wire(source, target, count:, from:, to:)` — fans `count` evenly-spaced `wire()` calls off a bus using `bus-frac`. `target` is polymorphic: a **bus name** (str) draws a bus-to-bus bundle (`to` applies); a **`(dx, dy)` offset** (array) draws free **stubs** of that displacement off each source point — for departing feeders / fans with no facing bar. The `from`/`to` `(start, end)` fraction pairs narrow or skew the bundle on each bar (e.g. `from: (0.2, 0.8)` for a 60 %-wide bundle; to land a bundle on the cable band of a bar that overshoots its cables by `over`, pass `from: (over/L, 1 - over/L)` where `L` is the bar length). `count: 1` draws a single coupler at the band midpoint.
- `bus-run(name, start, stations, pitch:, lead:, bus-length:, angle:, tail:, device:)` — a feeder run of node buses at length-proportional spacing, driven by a station table `(name:, length:, device:, caption:, label:, side:)`. Every station is a real bus named `<run>-<station>`, so branches/ties attach by anchor; devices are drawn before the ticks (bars cover lead roots). See the urban-lv recipe.
- `area(name, a, b, title:, side:, inside:, stroke:, fill:, radius:)` — the boundary/backdrop rectangle that groups part of a network (station envelope, feeder boundary, plant area), with a title tucked inside (or outside) any compass side/corner. Draw areas first — they're backdrops. The rect is a *named* CeTZ element, so `<name>.west` etc. stay usable for routing. Border may be crossed by leads but must not slice a symbol body.
- `flow-arrow(from, to, label:, side:, stroke:, scale:)` — annotation arrow (power-flow / current direction / legend entries / OLTC arrows), with an optional `note` caption at its midpoint. It always rebuilds the arrowhead's mark stroke solid from the line's paint+thickness, so dashed arrows keep clean heads (the classic CeTZ dashed-mark gotcha). Annotations only — conductors are `wire()`.
- `phase-ticks(pos, angle:, count:, spacing:, length:, slant:, stroke:)` — the slanted slash marks across a conductor stating its phase/conductor count (3 = three-phase). `angle` is the conductor direction; `pos` is any coord (lerp between anchors is typical).
- `note(pos, body, side:)` — drops a free-floating text label beside any coordinate/anchor/lerp, picking the label anchor opposite to `side` so the text sits cleanly on the requested side. Use it for captions on wires (which can't take labels) and tap points.
- `feeder(name, start, stations, ...)` — draws a distribution feeder: a straight run from `start` with an evenly-spaced tap per entry in the `stations` data list, an optional transformer+`load` "drop" under each (down, or up with `up: true`), per-segment `currents` labels (N+1 of them, `none` to skip), and a dashed continuation. `stations` is a list of `(label:, load:)` dicts (omit `load` for a bare tap). `lead`/`spacing`/`tail`/`extend` size the run. It composes `wire`/`transformer`/`load`/`note` — see the feeder-compensation recipe.
- `dali(name, pos, ...)` — draws a DALI-style metering unit hanging from a line: a CT clamp *encircling the measured line* for I, a voltage transformer (the reused `transformer` symbol, `<name>-vt`, configured via `tx-radius`/`tx-distance`/`tx-stroke`/`tx-fill`) on a tap wire for V, and a labelled box below (`label:` defaults to `[DALI]`, so it relabels for any CT+VT box). Vertical layout `line → lead → V transformer → tail → box`; `width` sets the I↔V tap distance, `lead`/`tail` the symbol/box gaps, `box-width`/`box-height` the box. It names its three parts — box `<name>`, clamp `<name>-ct`, transformer `<name>-vt` — but draws **no** I/V captions: anchor your own `note`s to them (e.g. `note("<name>-ct.west", [I])`). See the reactive-flow recipe.

New helpers belong here when they compose existing primitives; anything that draws its own geometry should be a symbol under `src/symbols/` instead.

### Canvas wrapper

`diagram(body)` (in `src/canvas.typ`) is the user-facing entry point. It calls `cetz.canvas` and inserts the entire `default` style dict from `styles.typ` under `ctx.style.cetz-power`. **Always start a diagram with `diagram { ... }`** — calling raw `cetz.canvas` would leave `ctx.style.cetz-power` unset and every symbol would fall back to hard-coded literal defaults from its `draw` closure. In HTML compilation mode (`--features html --input html=true`) the wrapper additionally wraps the canvas in `html.frame(...)` so it renders as inline SVG; CeTZ's `layout()`-based sizing produces nothing in HTML mode otherwise. PDF builds are unaffected.

### Import convention

The canonical user-facing import is the wildcard form:

```typst
#import "@preview/cetz-power:0.1.0": *

#diagram({
  bus("b1", (0, 0))
  transformer("t", "b1.mid", (3, 0))
})
```

The wildcard puts every symbol — `diagram`, `bus`, `bus-frac`, `wire`, `elbow`, `external-grid`, `transformer`, `load`, `pv-panel`, `machine`, `multi-wire`, plus the re-exported `cetz` module — directly in scope. The repo's docs, README, examples, and tests all follow this convention. The namespaced form `#import "..." as pg` + `pg.diagram(...)` still works (and is documented as an alternative for users who want to keep cetz-power's names out of their global namespace), but new examples should use the wildcard form.

### Tests

`tests/harness.typ` exports `test(body)` which sets the page to auto-size with a 4pt margin, inserts a weak pagebreak, and wraps `body` in `diagram`. Each test file is a sequence of `#test({ ... })` calls; they all compile to a single multi-page SVG. The convention is: short, declarative scenes covering each variant of the symbol under test. There is no test framework — "compiles cleanly" is the assertion.

## Style override pattern

Three layers, lowest precedence first:

```typst
// 1. Global defaults (set once, persist for the canvas)
cetz.draw.set-style(cetz-power: (stroke: 1.2pt))

// 2. Family defaults
cetz.draw.set-style(cetz-power: (transformer: (radius: 0.4)))

// 3. Per-call (named arg on the symbol call)
transformer("t1", "b1.tap2", (3, 0), radius: 0.5, stroke: red)
```

`resolve-style` only copies *scalar* top-level keys down into the merged dict (dictionaries like `label:` are not auto-flattened). Family dicts can themselves contain a `label:` sub-dict that overrides the base label dict — see `transformer` and `bus` in `styles.typ`.
