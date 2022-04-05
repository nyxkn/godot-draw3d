tool
extends Spatial


func _ready() -> void:
	var primitives = $Primitives
	primitives.points(random_vertices(20, Vector3(4, 0, 0)), Color.green)
	primitives.line_colored(random_colored_vertices())

	# single draw per Draw3D instance. easily transformable
	$Sphere.sphere(2.0, Color.cyan)
	$TransformMe.circle_XY()
	$TransformMe.points([Vector3.ZERO])


func _process(delta: float) -> void:
	var time = OS.get_ticks_msec() * 0.001

	$TransformMe.rotate_x(delta)
	$TransformMe.translation.x = 9 + cos(time)
	$Sphere.rotate_y(delta)

	var arcs = $Arcs
	arcs.clear()
	arcs.circle(Vector3(0, 0, 0), Basis(Vector3(1, time, 0)), Color.purple)
	arcs.arc(Vector3(4, 0, 0), Basis(Vector3(0, TAU/6, 0)).scaled(Vector3(2, 2, 2)), TAU/8, TAU/3, false)
	arcs.arc_normal(Vector3(-4, 0, 0), Vector3(-1, -1, -1).normalized(), TAU/8, TAU/3, 2.0, true)
	arcs.circle_normal(Vector3(-8, 0, 0), Vector3(0, 0, 1).normalized(), 1.0, Color.pink)
	arcs.arc_XY(Vector3(8, 0, 0), -TAU/4, TAU/4)

	var shapes = $Shapes
	shapes.clear()
	shapes.cube(Vector3(0, 0, 0), Basis(Vector3(0, time, 0)).scaled(Vector3(1, 1.5, 1)), Color.yellow)
	shapes.cube_up(Vector3(4, 0, 0), Vector3(1, 0.5, 0.5), Color.orangered)

	var plane = $SinglePlane
	plane.clear()
	plane.circle(Vector3(-4, 0, 0))
	plane.circle_XY(Vector3(0, 0, 0), 1.5, Color.blue)
	plane.circle_XZ(Vector3(4, 0, 0), 1, Color.red)


func random_vertices(n: int = 20, offset: Vector3 = Vector3.ZERO) -> Array:
	var vertices = []
	for i in n:
		var vertex = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1))
		vertices.push_back(vertex + offset)
	return vertices


func random_colored_vertices(n: int = 10) -> Array:
	var vertices = []
	for i in n:
		var colored_vertex = []
		colored_vertex.resize(2)
		colored_vertex[0] = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1))
		colored_vertex[0] *= 1.5
		colored_vertex[1] = $Primitives.random_color()
		vertices.push_back(colored_vertex)
	return vertices
