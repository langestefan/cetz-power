#import "/src/lib.typ": *
#set page(margin: 10pt, width: auto, height: auto)
#set text(size: 7pt)

// A hybrid renewable park at its point of connection. The external
// grid feeds the 10 kV collector bus through an OLTC transformer with
// a metering CT; the bus serves three plant bays (wind park, PV park
// and a converter-coupled battery), a fused capacitor bank, the park
// auxiliaries and a normally-open ring tie. A park controller closes
// a dashed signal loop: CT measurement in, battery dispatch out.
#diagram(length: 1cm, {
  let dashed = (paint: black, thickness: 0.7pt, dash: "dashed")
  let sig(..pts) = {
    let pts = pts.pos()
    if pts.len() > 2 {
      cetz.draw.line(..pts.slice(0, -1), stroke: dashed)
    }
    flow-arrow(
      pts.at(pts.len() - 2),
      pts.at(pts.len() - 1),
      stroke: dashed,
      scale: 0.9,
    )
  }

  // Backdrop for the plant bays.
  area(
    "park",
    (0.8, 0.7),
    (6.25, 3.95),
    title: [Hybrid park],
    side: "south-west",
  )

  // ── Grid infeed with metering ───────────────────────────────────
  external-grid("grid", (3.5, 5.8), size: 0.8)
  transformer(
    "tmain",
    (3.5, 5.8),
    (3.5, 4.75),
    radius: 0.26,
    distance: 0.24,
    oltc: true,
    vector: ("delta", "wye"),
  )
  wire((3.5, 4.75), (3.5, 4.1))
  ct("ct1", (3.5, 4.45), angle: 90deg)
  flow-arrow((2.7, 4.6), (2.7, 5.4), label: [$P , Q$], side: "west")

  // ── Plant bays at equidistant taps ──────────────────────────────
  // (drawn before the bus so the bar covers the lead roots)
  let bay(x, k, cap, mid) = {
    wire((x, 4.1), (x, 3.85))
    breaker("cb-" + k, (x, 3.85), (x, 3.3))
    wire((x, 3.3), (x, 3.1))
    mid(x)
    wire((x, 2.4), (x, 2.25))
    plant(
      "p-" + k,
      (x, 1.9),
      kind: k,
      label: (content: cap, anchor: "south", distance: 0.12),
    )
  }
  let tx(x) = transformer(
    "t-" + str(int(x * 10)),
    (x, 3.1),
    (x, 2.4),
    radius: 0.16,
    distance: 0.15,
  )
  let conv(x) = {
    converter("cnv", (x, 2.75), size: 0.6, kind: "ac-dc")
    wire((x, 3.1), (x, 3.05))
  }
  bay(1.6, "wind3", [Wind 12 MW], tx)
  bay(3.5, "pv3", [PV 8 MW], tx)
  bay(5.4, "bess2", [BESS 4 MWh], conv)

  // ── Grid assets on the bus ──────────────────────────────────────
  // Fused capacitor bank.
  wire((6.6, 4.1), (6.6, 3.85))
  fuse("fu1", (6.6, 3.85), (6.6, 3.3))
  wire((6.6, 3.3), (6.6, 3.2))
  capacitor("cbk", (6.6, 3.2), angle: 180deg, lead-in: 0.12, lead-out: 0.12)
  ground("gcb", (6.6, 2.84))
  note((6.78, 3.02), [2 Mvar], side: "east", size: 6pt)

  // Park auxiliaries.
  load("laux", (7.4, 4.1), size: 0.22, lead: 0.2, label: (
    content: [aux],
    distance: 0.08,
  ))

  // Normally-open ring tie to the neighbouring feeder.
  elbow((2.4, 4.1), (0.6, 4.75), corner: "v")
  junction("nop", (1.4, 4.75), open: true)
  note((0.55, 4.75), [NOP], side: "west", size: 6pt)

  // ── Collector bus (drawn last: it covers the lead roots) ────────
  bus("mv", (1.0, 4.1), (8.0, 4.1), label: (content: [10 kV], anchor: "west"))

  // ── Park controller: measurement in, battery dispatch out ───────
  block(
    "ppc",
    (8.55, 1.9),
    width: 1.0,
    height: 0.6,
    fill: luma(238),
    body: [PPC],
  )
  // (the CT's compass anchors rotate with the symbol, so address its
  // east edge explicitly)
  sig((3.66, 4.45), (8.55, 4.45), (8.55, 2.2))
  sig((8.05, 1.9), "p-bess2.east")
  note((6.9, 1.98), [$P^*$], side: "north", size: 6pt)
})
