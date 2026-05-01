# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`cetz-power` is a Typst package that draws power-system single-line diagrams. It is a thin wrapper around [CeTZ](https://github.com/cetz-package/cetz) `0.4.2` (pinned in `src/deps.typ`). Package metadata lives in `typst.toml`; the entry point is `src/lib.typ`, which re-exports the canvas wrapper, every symbol in `src/symbols/`, and the composition helpers in `src/helpers.typ`.

## Common commands

- Run the whole test suite: `./tests/run.sh`
- Run a single suite (or a few): `./tests/run.sh bus wire transformer` — argument is the directory name under `tests/`.
- Compiler selection: the script first tries `$COMPILER` (default `../tsc.js`, a node wrapper expected one level above the repo root) and falls back to the system `typst` CLI. To force the CLI: `COMPILER=/dev/null ./tests/run.sh` (or just install `typst` and remove the wrapper).
- Each test compiles `tests/<name>/test.typ` → `tests/<name>/out/test.svg`. There is no automatic image-diff step; failure means "did not compile". `tests/<name>/ref/` images, if added, are for manual comparison only.
- Build the docs locally: `cd docs && npm ci && npm run dev`. Live preview at `http://localhost:4321/cetz-power/`. `npm run build` produces a static site under `docs/dist/`.
- The docs are an [Astro Starlight](https://starlight.astro.build) site. Prose lives in MDX under `docs/src/content/docs/`; Typst diagrams live as standalone snippets under `docs/snippets/<name>.typ` and are compiled to SVG by `docs/scripts/build-diagrams.mjs` into `docs/public/diagrams/<name>.svg`. The `<Snippet name="..." />` component (defined in `docs/src/components/Snippet.astro`) reads the snippet source at build time and renders it side-by-side with its SVG.
- The deployed docs are built and pushed to GitHub Pages by `.github/workflows/docs.yml` on every push to `main`. CI runs Node 22 (Astro 6 requires Node ≥22.12); local dev needs the same.

## Architecture

### Symbol families

`src/symbols/` is organised into four category sub-directories that mirror the docs sidebar:

- `src/symbols/grid/` — network infrastructure (`bus`, `wire`, `external-grid`, `transformer`)
- `src/symbols/generation/` — sources (`machine`, `pv-panel`)
- `src/symbols/loads/` — energy consumers (`load`)
- `src/symbols/electrical/` — passive components, sources, and ground (`capacitor`, `resistor`, `inductor`, `diode`, `voltagesource`, `currentsource`, `ground`)
- `src/symbols/protection/` — switchgear and overcurrent protection (`switch`, `breaker`, `fuse`)

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

`bus()` is special: it has a `length` (or two endpoints), and exposes `start`, `mid`, `end`, plus N evenly-spaced `tap1..tapN` anchors when called with `taps: N`. Use `bus-frac("b1", 0.25)` to address a fractional point — it returns a CeTZ lerp coordinate `(b1.start, 0.25, b1.end)` evaluated lazily.

### Wires are not symbols

`wire()` and `elbow()` in `src/symbols/wire.typ` skip the `symbol()` machinery entirely (no label, no family-style cascade). They only read `cetz-power.wire.stroke` from the active style and draw a `cetz.draw.line`. Don't try to give them labels — wrap a labelled box around them instead, or attach the label to the symbol on either end.

### Composition helpers

`src/helpers.typ` is for short combinations of existing primitives that would otherwise force the caller to write the same loop or coordinate math repeatedly — it is **not** for new symbols. Currently it only exports `multi-wire(source, target, count:, from:, to:)`, which fans `count` evenly-spaced `wire()` calls between two buses using `bus-frac`. The `from`/`to` `(start, end)` fraction pairs let the caller narrow or skew the bundle on either bar (e.g. `from: (0.2, 0.8)` for a 60 %-wide bundle, asymmetric pairs for a fan-out). New helpers belong here when they compose existing primitives; anything that draws its own geometry should be a symbol under `src/symbols/` instead.

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
