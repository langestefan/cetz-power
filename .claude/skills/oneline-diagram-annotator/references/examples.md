# Worked examples

Two complete networks showing how a figure maps to a `Topology`. Use these as
patterns; coordinates are illustrative for those specific images.

## 1. CIGRE MV (radial, two feeders, a tie switch)

Shipped in full as `annotator.cigre_mv_topology()`. Structure to copy:

- **HV/source bus** `0` (one wide horizontal bar) feeding two 110/20 kV
  transformers, each with a breaker on top (`Q1`,`Q2`) — the top chain that's easy
  to miss.
- **Feeder 1** trunk taps buses 1→2→3 down a single conductor column (interior
  taps), then branches from bus 3.
- **Bus 9 is VERTICAL** — a tall bar that two conductors enter from the sides, with
  a load leaving the bottom via an **elbow**. Classic orientation gotcha.
- **Tie line** 7→S1→Feeder 2: the switch S1 is *seated on* the 2.0 km conductor; if
  it floats above the line, snap its y to the real conductor row.
- Buses widen to their **load-arrow taps** (e.g. bus 4 runs left to where its load
  hangs), not just to the dense centre of the bar.

```python
import annotator as A
im, dark, _ = A.build_masks("cigre_mv.png")
topo = A.cigre_mv_topology()
print(A.refine_all(dark, topo))     # ~0.94 bus / ~0.99 line coverage
A.render(im, topo, "mv_annotated.png")
```

## 2. CIGRE LV (transformer + three feeders of point-nodes)

Different shape: nodes are **filled dots** (junctions), not bars. Model the two
real busbars as `Bus`, and treat every R/C/I node as a tap by giving each hop its
own `Edge`.

```python
import annotator as A
from annotator import Bus, Edge, Topology

im, dark, _ = A.build_masks("cigre_lv.png")

buses = [Bus("MV","h",169,382,492), Bus("LV","h",257,131,760)]

# residential trunk: one edge per 35 m hop so each node becomes a tap
xR, LVy = 191, 257
res = [(xR,LVy),(xR,320),(xR,386),(xR,433),(xR,481),(xR,546),(xR,607),(xR,667),(xR,732)]
edges = [Edge("35m" if i==0 else "", [res[i], res[i+1]]) for i in range(len(res)-1)]
# branches, e.g. R3 -> R9 -> R10 -> R11 (35 m each), R2 -> R8 (30 m), etc.
edges += [Edge("35m", [(xR,433),(249,433)]), Edge("35m", [(249,433),(302,433)])]

topo = Topology(
    buses, edges,
    feeders=[[(435,170),(435,187)],[(435,235),(435,257)]],  # transformer leads
    switches=[("S2",432,143)],
    transformers=[("T",435,200,222,13)],                    # 11/0.4 kV double-circle
)
A.refine_all(dark, topo)
A.render(im, topo, "lv_annotated.png")
```

Lesson carried over: the LV feeders are upright so axis-aligned refinement just
confirms the seeds; the work was reading which dot is which node and wiring the
hops. Let the figure keep its own "35m"/"R7" labels — don't duplicate them.

## 3. Small per-unit study system (4-bus, diagonal lines, sources)

Different again: short bus bars (1,2 **vertical**; 3,4 **horizontal**), impedance
labels in pu, two diagonal lines, and rotating-machine sources.

Key points this example teaches:
- **Multi-segment lines.** 1→3 goes horizontal, then diagonal, then vertical into
  bus 3; 2→3 is the mirror. Route the polyline through the real corners:
  `Edge("0.0024 + j 0.025 pu", [(81,92),(143,92),(209,176),(209,190)])`.
- **Sources align with their stub.** `generators=[("S",40,67,20),("G",416,54,21)]`
  with feeder stubs from the circle edge to the bus centre
  (`[(60,67),(81,67)]`, `[(384,54),(396,54)]`).
- **Loads anchor at the bus.** `loads=[("400 MW",209,216),("400 MW",209,277)]` — the
  y is near each bus, not at the far arrow tip, so the netlist maps them to 3 and 4.
- **Netlist falls out for free:**
  ```python
  print(A.netlist_text(topo))
  # branches 1-2,1-3,2-3,3-4,2-4 with parsed r,x; generators @1,2; loads @3,4
  ```
