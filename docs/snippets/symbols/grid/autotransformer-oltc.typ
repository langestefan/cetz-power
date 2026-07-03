#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Coupling two voltage levels, with the usual on-load tap changer.
  bus("hv", (0, 1.1), length: 1.6, label: [380 kV])
  bus("lv", (0, -1.1), length: 1.6, label: (
    content: [220 kV],
    anchor: "south",
  ))
  autotransformer("t", (0, 1.1), (0, -1.1), oltc: true)
})
