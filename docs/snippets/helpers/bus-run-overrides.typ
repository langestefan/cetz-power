#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Per-station overrides: `lead` spacing when there is no length, a
// custom segment label and caption, a flipped label side, and a tail.
#diagram(length: 1.2cm, {
  bus-run(
    "r",
    (0, 0),
    (
      (name: "a"),
      (name: "b", length: 30, label: [0.4 km], caption: [B#sub[1]]),
      (name: "c", length: 20, side: "south"),
      (name: "d", length: 25, caption: none),
    ),
    tail: 0.5,
  )
})
