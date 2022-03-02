tool
extends Spatial


func _ready() -> void:
	var primitives = $Primitives/Draw3D
	primitives.clear()
	primitives.points(random_vertices(), Color.green)
	primitives.line_colored(random_colored_vertices())
	

func _process(delta: float) -> void:
	pass
#
#
#
##	return
##	d.clear()
#
#
##	d.circle_XZ(Vector3(0, 0, 0))
#
##	d.circle_XY(Vector3(2, 0, 0))
##	d.circle_XZ(Vector3(4, 0, 0))
#
#	var arcs = $Arcs/Draw3D
#	arcs.clear()
#	arcs.circle(Vector3(0, 0, 0), Basis(Vector3(TAU/6, TAU/6, 0)))
##	arcs.circle_normal(Vector3(1, 0, 0), Vector3(1, 1, 1).normalized(), 2.0)
##	arcs.arc_normal(Vector3(-8, 0, 0), Vector3(1,1,1).normalized(), TAU/8, TAU/3, 1.0, false)
##	arcs.arc_2d(Vector3(-4, 0, 0), -TAU/4, TAU/4)
#
##	var shapes = $Shapes/Draw3D
##	shapes.clear()
##	shapes.cube(


func random_vertices(n: int = 20) -> Array:
	var vertices = []
	for i in n:
		vertices.push_back(Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)))
	return vertices

func random_colored_vertices(n: int = 20) -> Array:
	var vertices = []
	for i in n:
		var colored_vertex = []
		colored_vertex.resize(2)
		colored_vertex[0] = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1))
		colored_vertex[1] = $Draw3D.random_color()
		vertices.push_back(colored_vertex)
	return vertices
