#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

// Stations sit at length-proportional distances; every one is a real
// named bus. Devices hang off the stations and are drawn before the
// ticks, so the bars cover the lead roots.
#diagram(length: 1.2cm, {
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
      (name: "2", length: 30, device: panel),
      (name: "3", length: 25, device: arrow),
    ),
  )
})
