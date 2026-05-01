#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Voltage-level colour coding — common in operations diagrams.
  // The thicker / hotter colours are the higher voltages, thinner
  // / cooler colours the lower. Buses match their feeders.
  let hv = rgb("#cc1122")     // 110 kV — red
  let mv = rgb("#bb6611")     // 11 kV  — orange
  let lv = rgb("#2244aa")     // 400 V  — blue

  bus("hv", (0, 0), length: 1.2, angle: 90deg,
    stroke: 2.4pt + hv,
    label: (content: align(center)[HV \ 110 kV]))
  bus("mv", (3, 0), length: 1.2, angle: 90deg,
    stroke: 1.8pt + mv,
    label: (content: align(center)[MV \ 11 kV]))
  bus("lv", (6, 0), length: 1.2, angle: 90deg,
    stroke: 1.4pt + lv,
    label: (content: align(center)[LV \ 400 V]))

  transformer("t1", "hv.mid", "mv.mid", radius: 0.25, label: [110 / 11 kV])
  transformer("t2", "mv.mid", "lv.mid", radius: 0.25, label: [11 / 0.4 kV])
})
