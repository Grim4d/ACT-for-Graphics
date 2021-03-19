using Catlab.WiringDiagrams

using Catlab.Graphics
import Catlab.Graphics: Graphviz

show_diagram(d::WiringDiagram) = to_graphviz(d,
  orientation=LeftToRight,
  labels=true, label_attr=:xlabel,
  node_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  ),
  edge_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  )
)

using Catlab.Theories

A, B, C, D = Ob(FreeBiproductCategory, :A, :B, :C, :D)
f = Hom(:f, A, B)
g = Hom(:g, B, C)
h = Hom(:h, C, D)

f

f, g, h = to_wiring_diagram(f), to_wiring_diagram(g), to_wiring_diagram(h)
f

show_diagram(f)