#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram({
  // One `lead:` sets lead-in and lead-out together — and the passives'
  // labels sit beside the body automatically.
  capacitor("c1", (0, 0), label: [default])
  capacitor("c2", (1.8, 0), lead: 0.55, label: [lead: 0.55])
  inductor("i1", (3.9, 0), lead: 0.4, label: [lead: 0.4])
  battery("b1", (6, 0), lead: 0.15, label: [lead: 0.15])
})
