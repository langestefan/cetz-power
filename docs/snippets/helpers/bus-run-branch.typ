#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Runs name their buses (`<run>-<station>`), so a sub-feeder branches
// off by anchor — no coordinates of bus 1 appear below.
#diagram(length: 1.2cm, {
  bus-run(
    "m",
    (0, 0),
    (
      (name: "1", length: 20),
      (name: "2", length: 25),
      (name: "3", length: 20),
    ),
  )
  let corner = ((rel: (0.4, 0), to: "m-1.mid"), "|-", (0, 1.5))
  wire((rel: (0, 0.3), to: "m-1.mid"), (rel: (0.4, 0.3), to: "m-1.mid"), corner)
  bus-run("s", corner, (
    (name: "4"),
    (name: "5", length: 20),
  ))
})
