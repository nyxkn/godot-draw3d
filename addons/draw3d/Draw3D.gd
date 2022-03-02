tool
extends ImmediateGeometry

##
## A small library for drawing simple shapes in 3D
##
class_name Draw3D, "res://addons/draw3d/CanvasItem.svg"


# https://www.khronos.org/opengl/wiki/Primitive
const CUBE_VERTICES := [
	# front 4 vertices
	Vector3( -1, -1, 1 ),
	Vector3( 1, -1, 1 ),
	Vector3( 1, 1, 1 ),
	Vector3( -1, 1, 1 ),
	# back 4 vertices
	Vector3( -1, -1, -1 ),
	Vector3( 1, -1, -1 ),
	Vector3( 1, 1, -1 ), 
	Vector3( -1, 1, -1 ),
]

const COLOR_DEFAULT: Color = Color.white

## Segment resolution of circles
export(int) var circle_resolution: int = 32

var current_color: Color = COLOR_DEFAULT
var point_size: int = 5
var line_width: int = 2 # currently unimplemented in godot

var m: SpatialMaterial

	
func _ready() -> void:
	print("ready")
	setup()

	
func setup() -> void:
	# material values affect everything drawn
	# if you need different parameters, you probably need to instance a new IM with a new material
	# i.e. we cannot change point_size on the fly for different draws,
	# as changing the value will change all previously drawn points as well
	m = SpatialMaterial.new()
	m.vertex_color_use_as_albedo = true
	m.flags_use_point_size = true
	change_point_size(point_size)
	change_line_width(line_width)
	set_material_override(m)
	
	
func rand_color() -> Color:
	return Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))
	

func points_test(clear: bool = false) -> void:
	clear && clear()
	
	begin(Mesh.PRIMITIVE_POINTS, null)
	for i in 100:
		set_color(rand_color())
		add_vertex(Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)))
	end()


func line_test(clear: bool = false) -> void:
	clear && clear()
	
	begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for i in 50:
		set_color(rand_color())
		add_vertex(Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)))
	end()


# this sets the default color for all following draws
# set_color() resets it to COLOR_DEFAULT
func set_color(color: Color = COLOR_DEFAULT) -> void:
	current_color = color


# this is a "change" and not a "set" because it changes the material properties,
# which affect everything that was previously drawn
func change_point_size(size: int) -> void:
	point_size = size
	m.params_point_size = point_size


func change_line_width(width: int) -> void:
	line_width = width
	m.params_line_width = line_width # currently unimplemented in godot
	
	
func draw_primitive(primitive_type: int, vertices: Array, color: Color = current_color) -> void:
	begin(primitive_type, null)
	for v in vertices:
		set_color(color)
		add_vertex(v)
	end()


func draw_primitive_colored(primitive_type: int, colored_vertices: Array, color: Color = current_color) -> void:
	begin(primitive_type, null)
	for i in colored_vertices.size():
		set_color(colored_vertices[i][1])
		add_vertex(colored_vertices[i][0])
	end()


# draw_primitive shortcuts

## Draw points
func points(vertices: Array, color: Color = current_color) -> void:
	draw_primitive(Mesh.PRIMITIVE_POINTS, vertices, color)

## Draw lines
func line(vertices: Array, color: Color = current_color) -> void:
	draw_primitive(Mesh.PRIMITIVE_LINE_STRIP, vertices, color)

## Draw lines closing the loop
func line_loop(vertices: Array, color: Color = current_color) -> void:
	draw_primitive(Mesh.PRIMITIVE_LINE_LOOP, vertices, color)


# draw_primitive_colored shortcuts

## Draw colored points
func points_colored(colored_vertices: Array) -> void:
	draw_primitive_colored(Mesh.PRIMITIVE_POINTS, colored_vertices)

## Draw colored lines
func line_colored(colored_vertices: Array) -> void:	
	draw_primitive_colored(Mesh.PRIMITIVE_LINE_STRIP, colored_vertices)



################################
# CIRCLE

## Generic function to draw a circle
func circle(position: Vector3, basis: Basis = Basis.IDENTITY, color: Color = current_color) -> void:
	# by default, this is a circle on the XZ plane. seems to make most sense in 3d as a highlight of objects
	
	var resolution = circle_resolution
	var transform = Transform(basis, position)

	var circle = []
	for i in resolution:
		var angle = TAU / resolution * i
		var angle_vector = Vector3(cos(angle), 0, sin(angle))
		angle_vector = transform.xform(angle_vector)
		circle.append(angle_vector)

	line_loop(circle, color)
	
	# also draw the points inbetween segments
#	points(circle, color)


###############################
# ARC

# angles in radians, obviously
func get_arc(angle_from: float, angle_to: float, transform: Transform = Transform.IDENTITY) -> PoolVector3Array:
	var arc2 = PoolVector2Array()
	
	var angle_total = angle_to - angle_from
	if angle_total > TAU:
		print("Angle is > TAU. We won't draw.")
		return PoolVector3Array()

	var resolution = lerp(1, circle_resolution + 1, angle_total / TAU)

	for i in resolution:
		var t = i / float(resolution - 1) # include the last point
		var angle = lerp(angle_from, angle_to, t)
		var angle_vector = Vector2(cos(angle), sin(angle))
		arc2.push_back(angle_vector)

	# convert to 3d
	var arc3 = PoolVector3Array()
	for p in arc2:
		arc3.push_back(Vector3(p.x, p.y, 0))
	
	# apply 3d transform
	for i in arc3.size():
		arc3[i] = transform.xform(arc3[i])
	
	return arc3


## Generic function to draw an arc
## Pass a Basis to define orientation
## Angle_from and Angle_to are in radians
## Optionally also draw the origin point and connect it with two lines on each end (a circular sector)
func arc(position: Vector3, basis: Basis, angle_from: float, angle_to: float,
			draw_origin: bool = false, color: Color = current_color):
				
	var arc: PoolVector3Array
	var transform = Transform(basis, position)
	
	if draw_origin:
		arc = PoolVector3Array()
		arc.push_back(transform.xform(Vector3.ZERO))
		arc.append_array(get_arc(angle_from, angle_to, transform))
		line_loop(arc, color)
	else:
		arc = get_arc(angle_from, angle_to, transform)
		line(arc, color)
	
	# also draw the points inbetween segments
#	points(arc, color)


################################
# CUBE - wireframe cube

## Draw a cube
## Pass a Basis argument to define orientation
func cube(position: Vector3, basis: Basis = Basis.IDENTITY) -> void:
	var vertices = CUBE_VERTICES.duplicate()
	var transform = Transform(basis, position)
	
	for i in vertices.size():
		vertices[i] = transform.xform(vertices[i])
	
	line_loop(vertices.slice(0, 3))
	line_loop(vertices.slice(4, 7))
	for i in 4:
		line([vertices[i], vertices[i+4]])


################################
# SPHERE - wireframe sphere

## Create a sphere shape
## This function returns an ImmediateGeometry node that you need to manually add to the scene with add_child
# this is so that you can translate it, as the add_sphere function doesn't have any parameters to define translation
func create_sphere(radius: float = 1.0, color: Color = current_color, lats: int = 16, lons: int = 16, add_uv: bool = true) -> ImmediateGeometry:
	var im_sphere = ImmediateGeometry.new()
	im_sphere.set_material_override(m)

	im_sphere.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	im_sphere.set_color(color)
	im_sphere.add_sphere(lats, lons, radius, add_uv)
	im_sphere.end()
	
	return im_sphere


################################
# SHORTCUTS - from normal

func basis_from_normal(normal: Vector3) -> Basis:
	var Y = normal.normalized()
	var X = Vector3(Y.y, -Y.x, 0)
	var Z = X.cross(Y)
	return Basis(X, Y, Z)


## Shortcut function to draw a circle whose plane is defined by a normal
## The normal should be normalized
func circle_normal(position: Vector3, normal: Vector3, radius: float = 1.0, color: Color = current_color) -> void:
	if normal.length() > 1.0:
		print("Normal vector should be normalized. We won't draw.")
		return
	
	var basis = basis_from_normal(normal)
	basis = basis.scaled(Vector3(radius, radius, radius))
	circle(position, basis, color)


## Shortcut function to draw an arc whose plane is defined by a normal
## The normal should be normalized
func arc_normal(position: Vector3, normal: Vector3, angle_from: float, angle_to: float, radius: float = 1.0, 
			draw_origin: bool = false, color: Color = current_color) -> void:
				
	if normal.length() > 1.0:
		print("Normal vector should be normalized. We won't draw.")
		return
	
	var basis = basis_from_normal(normal)
	basis = basis.scaled(Vector3(radius, radius, radius))
	arc(position, basis, angle_from, angle_to, draw_origin, color)


## Shortcut function to draw a cube whose orientation is defined by a normal
## The normal should be normalized
func cube_normal(position: Vector3, normal: Vector3, size: Vector3 = Vector3.ONE) -> void:
	if normal.length() > 1.0:
		print("Normal vector should be normalized. We won't draw.")
		return

	var basis = basis_from_normal(normal)
	basis = basis.scaled(size)
	cube(position, basis)


# basic upright cube with no rotation
## Shortcut function to draw a cube in its default orientation
func cube_up(position: Vector3, size: Vector3 = Vector3.ONE) -> void:
	var basis := Basis.IDENTITY.scaled(size)
	cube(position, basis)


################################
# SHORTCUTS - 2d drawing

func scale_basis(scale: float) -> Basis:
	return Basis.IDENTITY.scaled(Vector3(scale, scale, scale))


## Shortcut function to draw a circle lying on the XZ plane
func circle_XZ(center: Vector3, radius: float = 1.0, color: Color = current_color) -> void:
	var orientation = scale_basis(radius)
	circle(center, orientation)
	

## Shortcut function to draw a circle lying on the XY plane
func circle_XY(center: Vector3, radius: float = 1.0, color: Color = current_color) -> void:
	var orientation = scale_basis(radius)
	orientation = orientation.rotated(Vector3.RIGHT, TAU/4)
	circle(center, orientation)


## Shortcut function to draw a 2d arc
func arc_2d(center: Vector3, angle_from: float, angle_to: float, radius: float = 1.0, draw_origin = false, color: Color = current_color):
	arc(center, scale_basis(radius), angle_from, angle_to, draw_origin, color)
