tool
extends Spatial


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	pass
	
	
#	return
#	d.clear()


#	d.circle_XZ(Vector3(0, 0, 0))

#	d.circle_XY(Vector3(2, 0, 0))
#	d.circle_XZ(Vector3(4, 0, 0))

	var arcs = $Arcs/Draw3D
	arcs.clear()
	arcs.circle(Vector3(0, 0, 0), Basis(Vector3(TAU/6, TAU/6, 0)))
#	arcs.circle_normal(Vector3(1, 0, 0), Vector3(1, 1, 1).normalized(), 2.0)
#	arcs.arc_normal(Vector3(-8, 0, 0), Vector3(1,1,1).normalized(), TAU/8, TAU/3, 1.0, false)
#	arcs.arc_2d(Vector3(-4, 0, 0), -TAU/4, TAU/4)

#	var shapes = $Shapes/Draw3D
#	shapes.clear()
#	shapes.cube(
