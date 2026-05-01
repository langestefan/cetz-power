#import "/src/lib.typ": *
#set page(margin: 6pt, width: auto, height: auto)
#set text(size: 7pt)

// Figuur 9.29: Twee ongelijk ingestelde parallelle transformatoren.
// 150 kV → 10 kV substation with two parallel transformers on
// different tap settings, feeding a 60 MW / 60 Mvar load.
#diagram(length: 1.2cm, {
  // Spacing tuned so the multi-line power-flow blocks (each about
  // 1.5 units wide) sit clear of the transformer body in the middle
  // of the gap, and the transformer labels fit between T1 and T2
  // without overlapping either. Transformers are pulled in toward the
  // centerline so their flow-annotation rows sit well below the bus
  // labels at the top of each bar.
  let hs1-x = 3.0
  let ms1-x = 8.5
  let upper-y = 0.8
  let lower-y = -0.8
  let bus-len = 2.2

  // Voltage source — "Voedende net". Placed at the same y as T1's
  // wire so the V → HS1 → T1 → MS1 path reads as one continuous
  // horizontal line. Sits just to the left of HS1 (close in x).
  machine("M1", (1.3, upper-y), "V", label: (
    content: align(center)[Voedende net \ 80027 kW \ 75376 kvar],
    anchor: "south", distance: 0.15,
  ))

  // HS1 — 150 kV high-voltage substation bus.
  bus("hs1", (hs1-x, 0), length: bus-len, angle: 90deg, label: (
    content: align(center)[Onderstation HS1 \ 150,000 kV \ 0,000 °],
    anchor: "north", distance: 0.15,
  ))

  // MS1 — 10 kV medium-voltage substation bus.
  bus("ms1", (ms1-x, 0), length: bus-len, angle: 90deg, label: (
    content: align(center)[Onderstation MS1 \ 10,430 kV \ -8,396 °],
    anchor: "north", distance: 0.15,
  ))

  // Voltage-source feed into HS1 — lands at the same y as T1's wire
  // so the line continues straight through HS1 into T1 without a kink.
  wire("M1.east", (hs1-x, upper-y))

  // Upper parallel transformer T1. Label sits ABOVE T1 (anchor
  // "north") so it doesn't conflict with the upper flow-text row,
  // which now sits below the upper lead.
  transformer("t1", (hs1-x, upper-y), (ms1-x, upper-y), radius: 0.25,
    label: (
      content: align(center)[T1 \ trap: -8 \ 132 / 10 kV \ 87 %],
      anchor: "north", distance: 0.15,
    ),
  )

  // Lower parallel transformer T2 — different tap setting.
  transformer("t2", (hs1-x, lower-y), (ms1-x, lower-y), radius: 0.25,
    label: (
      content: align(center)[T2 \ trap: -9 \ 129,75 / 10 kV \ 98 %],
      anchor: "south", distance: 0.15,
    ),
  )

  // Power-flow annotations on the HS1 side. All four blocks sit
  // BELOW their respective transformer-lead line — anchor `north-*`
  // makes the text grow downward from the lead. Padding 0.10 leaves
  // a small gap between the lead line and the top of the text.
  cetz.draw.content((rel: (0.10, 0), to: (hs1-x, upper-y)),
    anchor: "north-west", padding: 0.10,
    align(left)[39664 kW \ 33976 kvar \ 201 A])
  cetz.draw.content((rel: (0.10, 0), to: (hs1-x, lower-y)),
    anchor: "north-west", padding: 0.10,
    align(left)[40363 kW \ 41400 kvar \ 223 A])

  // Power-flow annotations on the MS1 side. Negative — the
  // transformers are net consumers from MS1's perspective.
  cetz.draw.content((rel: (-0.10, 0), to: (ms1-x, upper-y)),
    anchor: "north-east", padding: 0.10,
    align(right)[-39652 kW \ -26935 kvar \ 2653 A])
  cetz.draw.content((rel: (-0.10, 0), to: (ms1-x, lower-y)),
    anchor: "north-east", padding: 0.10,
    align(right)[-40349 kW \ -33062 kvar \ 2888 A])

  // Output feeder + load on the right. `angle: 90deg` rotates the
  // default downward arrow CCW so the tip points east (away from
  // MS1) — the conventional "outgoing power" direction.
  wire("ms1.mid", (ms1-x + 2.0, 0))
  load("ld", (ms1-x + 2.0, 0), angle: 90deg, label: (
    content: align(center)[60000 kW \ 60000 kvar],
    anchor: "south", distance: 0.15,
  ))
})
