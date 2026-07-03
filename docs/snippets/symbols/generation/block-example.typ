#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // A device block wired to a bus through its east anchor.
  bus("b1", (2.2, 0), length: 1.0, angle: 90deg, label: [1])
  block("plant", (0, 0), body: [plant], label: [unit 1])
  wire("plant.east", "b1.mid")
})
