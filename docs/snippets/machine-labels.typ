#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  machine("a", (0, 0), "A",
    label: (content: align(center)[Asynchronous \ generator],
            anchor: "south", distance: 0.35))
  machine("g", (2.4, 0), "G",
    label: (content: [10 MVA], anchor: "east", distance: 0.25))
})
