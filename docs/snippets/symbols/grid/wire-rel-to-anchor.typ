#import "/src/lib.typ": *
#set page(margin: 4pt, width: auto, height: auto)

#diagram(length: 1.2cm, {
  // Bus-tie cable between two parallel substations. The cable
  // enters and leaves each bus PERPENDICULARLY with a fixed
  // standoff — `(rel: <vec>, to: <anchor>)` pins the approach and
  // landing points to each bus regardless of where the buses end
  // up on the page. Move either bus and the routing follows
  // automatically.
  bus("b1", (0, 0),    length: 1.2, angle: 90deg, label: [Sub 1])
  bus("b2", (3, -1.0), length: 1.2, angle: 90deg, label: [Sub 2])
  wire(
    "b1.mid",                          // start, anchored to bus 1
    (rel: (0.5, 0), to: "b1.mid"),     // approach: 0.5 east of b1.mid
    (rel: (-0.5, 0), to: "b2.mid"),    // landing:  0.5 west of b2.mid
    "b2.mid",                          // end, anchored to bus 2
  )
})
