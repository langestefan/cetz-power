# cetz-power

**Power-system single-line diagrams in Typst, on top of [CeTZ](https://github.com/cetz-package/cetz).**

Buses, transformers, machines, loads, switchgear, PV, windings, connection points — plus helpers for whole feeders and metering units.

**[Documentation & examples →](https://langestefan.github.io/cetz-power/)**

## Quick example

```typst
#import "@preview/cetz-power:0.1.0": *

#diagram({
  // A horizontal bus with 5 tap points
  bus("b1", (0, 0), length: 5, taps: 5)

  // External grid feeding into tap 1
  external-grid("grid", "b1.tap1", angle: 90deg)

  // A 2-winding transformer in the middle
  transformer("t1", "b1.tap3", (3, -2))

  // A load at the bottom of the transformer's secondary
  load("l1", (3, -2))
})
```

## Installation

Via Typst Universe (recommended once published):

```typst
#import "@preview/cetz-power:0.1.0": *
```

Or vendor locally by cloning the repo and importing from path:

```typst
#import "path/to/cetz-power/src/lib.typ": *
```

The wildcard form (`: *`) puts every symbol — `diagram`, `bus`, `transformer`, `wire`, … — directly in scope. If you'd rather keep them out of your top-level namespace, use `as pg` and write `pg.diagram(...)`, `pg.bus(...)` instead.

## What's in the box

| Category    | Symbols                                                                          |
|-------------|----------------------------------------------------------------------------------|
| Grid        | `bus`, `bus-frac`, `wire`, `elbow`, `junction`, `external-grid`, `transformer`, `transformer3` |
| Generation  | `machine`, `pv-panel`                                                            |
| Loads       | `load`                                                                           |
| Electrical  | `capacitor`, `resistor`, `inductor`, `diode`, `voltagesource`, `currentsource`, `ground`, `bolt` |
| Protection  | `switch`, `breaker` (square or `kind: "cross"`), `fuse`                          |
| Windings    | `delta`, `wye`, `zigzag`                                                         |
| Helpers     | `note`, `multi-wire`, `feeder`, `dali`                                           |

To add a symbol: drop a file under `src/symbols/<category>/`, wrap
`symbol()` from `src/core.typ`, export it from `src/lib.typ`.

## Design

- **Symbols have anchors.** Compass points, plus symbol-specific ones (`tap1..tapN`, `primary`/`secondary`, phase terminals).
- **One- or two-node placement.** One position + `angle:` drops a symbol in place; two positions orient it in→out with its own leads.
- **Cascading styles.** A global `set-style(cetz-power: (...))` changes defaults; per-family overrides live under e.g. `cetz-power.transformer`; per-call arguments override both.
- **Labels everywhere.** Every symbol accepts `label:` as a string, content, or `(content:, anchor:, distance:)` dict.

## Running the tests

```bash
tests/run.sh
```

Compiles every test file into `tests/<name>/out/*.svg` and (if reference images exist in `ref/`) does a rough diff.

## Building the docs

The docs are an [Astro Starlight](https://starlight.astro.build) site under `docs/`. Prose is MDX, Typst diagrams are standalone snippets under `docs/snippets/` (in category sub-folders) that get pre-compiled to SVG and embedded via a small `<Snippet>` component. Astro 6 requires Node ≥22.12.

```bash
cd docs
npm ci
npm run dev      # live preview at http://localhost:4321/cetz-power/
npm run build    # static site → docs/dist/
```

The deployed docs are built and pushed to GitHub Pages on every push to `main` by `.github/workflows/docs.yml`.

## Claude Code skills

`.claude/skills/` ships two [Claude Code](https://claude.com/claude-code) skills, picked up automatically when you open the repo:

- **`cetz-power-diagrams`** — authoring know-how: symbol catalog, design rules, figure-replication workflow.
- **`oneline-diagram-annotator`** — digitises a raster one-line diagram into exact coordinates (RANSAC fitting). First use:

  ```bash
  cd .claude/skills/oneline-diagram-annotator
  python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
  ```

## License

MIT. See `LICENSE`.
