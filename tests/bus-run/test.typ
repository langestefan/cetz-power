#import "/tests/harness.typ": test
#import "/src/lib.typ": *

// Minimal run: three stations at length-proportional pitch.
#test({
  bus-run(
    "r",
    (0, 0),
    (
      (name: "1", length: 20),
      (name: "2", length: 30),
      (name: "3", length: 25),
    ),
  )
})

// Lead spacing (no length, no label), tail, and caption/label overrides.
#test({
  bus-run(
    "r",
    (0, 0),
    (
      (name: "a"),
      (name: "b", length: 30, label: [0.4 km], caption: [B#sub[1]]),
      (name: "c", length: 20, caption: none),
    ),
    tail: 0.5,
  )
})

// Devices hang off the stations (drawn under the ticks); per-station
// override and a flipped label side.
#test({
  let arrow(info) = load(
    info.name,
    (rel: (0, -0.3), to: info.at),
    elbow: 0.25,
    size: 0.18,
    lead: 0.15,
  )
  let panel(info) = pv-panel(
    info.name,
    (rel: (0, -0.3), to: info.at),
    elbow: 0.3,
    size: 0.2,
    lead: 0.1,
  )
  bus-run(
    "r",
    (0, 0),
    (
      (name: "1", length: 20, device: arrow),
      (name: "2", length: 25, device: panel, side: "south"),
      (name: "3", length: 20, device: arrow),
    ),
  )
})

// Vertical run: ticks horizontal, labels rotated, captions west.
#test({
  bus-run(
    "v",
    (0, 0),
    (
      (name: "1", length: 20),
      (name: "2", length: 25),
    ),
    angle: -90deg,
  )
})

// Branching off a station by anchor: a riser to a sub-run.
#test({
  bus-run(
    "m",
    (0, 0),
    (
      (name: "1", length: 20),
      (name: "2", length: 25),
    ),
  )
  wire((rel: (0, 0.3), to: "m-1.mid"), (rel: (0.4, 0.3), to: "m-1.mid"), (
    (rel: (0.4, 0), to: "m-1.mid"),
    "|-",
    (0, 1.6),
  ))
  bus-run(
    "s",
    ((rel: (0.4, 0), to: "m-1.mid"), "|-", (0, 1.6)),
    (
      (name: "s1"),
      (name: "s2", length: 20),
    ),
  )
})
