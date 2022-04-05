tool
extends ImmediateGeometry

##
## A small library for drawing simple shapes in 3D.
##
## Usage is similar to the custom drawing in 2D that is already present in Godot:
##
## https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html
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
const POINT_SIZE_DEFAULT: int = 8
const LINE_WIDTH_DEFAULT: int = 2

## Number of segments that will be used to draw a circle.
##
## Also applies for the resolution of arcs.
##
export(int) var circle_resolution: int = 32

## This holds the color value to use unless overridden by the specific draw functions.
##
## Change this with change_color().
##
var current_color: Color = COLOR_DEFAULT setget change_color

var point_size: int = POINT_SIZE_DEFAULT
var line_width: int = LINE_WIDTH_DEFAULT # currently unimplemented in godot

var m: SpatialMaterial


func _ready() -> void:
	set_material()


func set_material() -> void:
	# material values affect everything drawn
	# if you need different parameters, you probably need to instance a new IM with a new material
	# i.e. we cannot change point_size on the fly for different draws,
	# as changing the value will change all previously drawn points as well
	m = SpatialMaterial.new()

	m.vertex_color_use_as_albedo = true
	m.flags_use_point_size = true
	m.flags_unshaded = true
	change_point_size(point_size)
	change_line_width(line_width)

	set_material_override(m)


## Change point size.
##
## This applies to all points currently and previously drawn.
##
## Call without arguments to reset to the default size.
##
func change_point_size(size: int = POINT_SIZE_DEFAULT) -> void:
	# NOTE: this changes the material properties, also affecting everything that was previously drawn
	point_size = size
	m.params_point_size = point_size


## Change line width.
##
## Call without arguments to reset to the default width.
##
## *This is currently unimplemented in Godot and has no effect.*
##
func change_line_width(width: int = LINE_WIDTH_DEFAULT) -> void:
	line_width = width
	m.params_line_width = line_width # currently unimplemented in godot


## Change default color for all subsequent draws.
##
## Call without arguments to reset to the default color.
##
func change_color(color: Color = COLOR_DEFAULT) -> void:
	current_color = color


## Helper function that returns a random color.
func random_color() -> Color:
	return Color(rand_range(0,1), rand_range(0,1), rand_range(0,1))


func points_test(clear: bool = false) -> void:
	clear && clear()

	begin(Mesh.PRIMITIVE_POINTS, null)
	for i in 100:
		set_color(random_color())
		add_vertex(Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)))
	end()


func line_test(clear: bool = false) -> void:
	clear && clear()

	begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for i in 50:
		set_color(random_color())
		add_vertex(Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)))
	end()



################################
# draw_primitive

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


################################
# draw_primitive shortcuts

## Draw points at the given vertices.
## Vertices are supplied as an Array of Vector3 coordinates.
func points(vertices: Array, color: Color = current_color) -> void:
	draw_primitive(Mesh.PRIMITIVE_POINTS, vertices, color)

## Draw line segments between the given vertices.
## Vertices are supplied as an Array of Vector3 coordinates.
func line(vertices: Array, color: Color = current_color) -> void:
	draw_primitive(Mesh.PRIMITIVE_LINE_STRIP, vertices, color)

## Draw looping line segments between the given vertices.
## I.e. the last point connects back to the first.
## Vertices are supplied as an Array of Vector3 coordinates.
func line_loop(vertices: Array, color: Color = current_color) -> void:
	draw_primitive(Mesh.PRIMITIVE_LINE_LOOP, vertices, color)


################################
# draw_primitive_colored shortcuts

## Draw points from an Array of *colored vertices*.
##
## A *colored vertex* is an Array with a Vector3 vertex and a Color value:
##
## `[ vertex: Vector3, color: Color ]`
##
## This allows you to draw points with individual colors.
##
func points_colored(colored_vertices: Array) -> void:
	draw_primitive_colored(Mesh.PRIMITIVE_POINTS, colored_vertices)

## Draw line segments from an Array of *colored vertices*.
##
## A *colored vertex* is an Array with a Vector3 vertex and a Color value:
##
## `[ vertex: Vector3, color: Color ]`
##
## This allows you to draw line segments that blend between the colors of the two surrounding vertices.
##
func line_colored(colored_vertices: Array) -> void:
	draw_primitive_colored(Mesh.PRIMITIVE_LINE_STRIP, colored_vertices)



################################
# CIRCLE

## Generic function to draw a circle.
##
## Pass a Basis argument to define orientation.
## Otherwise defaults to lying on the XZ plane.
##
func circle(position: Vector3 = Vector3.ZERO, basis: Basis = Basis.IDENTITY, color: Color = current_color) -> void:
	# by default, this is a circle on the XZ plane.
	# this seems to make most sense in 3d as a highlight of objects

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

func get_arc(angle_from: float, angle_to: float, transform: Transform = Transform.IDENTITY) -> PoolVector3Array:
	# angles in radians, obviously

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


## Generic function to draw an arc.
##
## Pass a Basis argument to define orientation.
##
## Angle_from and Angle_to are in radians.
##
## Optionally also draw the origin point and connect it with two lines on each end
## (a circular sector).
##
func arc(position: Vector3, basis: Basis, angle_from: float, angle_to: float, draw_origin: bool = false, color: Color = current_color):
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

## Generic function to draw a cube.
##
## Pass a Basis argument to define orientation.
## Otherwise defaults to no orientation.
##
func cube(position: Vector3 = Vector3.ZERO, basis: Basis = Basis.IDENTITY, color: Color = current_color) -> void:
	var vertices = CUBE_VERTICES.duplicate()
	var transform = Transform(basis, position)

	for i in vertices.size():
		vertices[i] = transform.xform(vertices[i])

	line_loop(vertices.slice(0, 3), color)
	line_loop(vertices.slice(4, 7), color)
	for i in 4:
		line([vertices[i], vertices[i+4]], color)


################################
# SPHERE - wireframe sphere

## Create a sphere shape.
##
## This does not take a position vector, so it will always be drawn at (0, 0, 0)
##
## It's best to draw the sphere on a dedicated Draw3D node so you can manipulate it by adjusting the
## transform properties.
##
func sphere(radius: float = 1.0, color: Color = current_color, lats: int = 16, lons: int = 16, add_uv: bool = true) -> void:
	begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	set_color(color)
	add_sphere(lats, lons, radius, add_uv)
	end()


################################
# SHORTCUTS - from normal

func basis_from_normal(normal: Vector3) -> Basis:
	# technically don't need to normalize again since we're already checking. but just in case.
	var Y = normal.normalized()
	var X = Vector3(Y.y, -Y.x, 0)
	# covering the edge case where our normal is (0, 0, 1)
	if X.length_squared() == 0: X = Vector3(-1, 0, 0)

	var Z = X.cross(Y)
	return Basis(X, Y, Z)


func check_normalization(normal: Vector3) -> bool:
	# the normal should be normalized
	# we could normalize silently but it's good to double check with the user -
	# to make sure that they're sending the right data
	if normal.is_normalized() == false:
		print("Normal vector should be normalized. We won't draw.")
		return false

	return true

## Shortcut function to draw a circle whose plane is defined by a normal.
##
## The normal should be normalized.
##
func circle_normal(position: Vector3, normal: Vector3, radius: float = 1.0, color: Color = current_color) -> void:
	if ! check_normalization(normal): return

	var basis = basis_from_normal(normal)
	basis = basis.scaled(Vector3(radius, radius, radius))
	circle(position, basis, color)


## Shortcut function to draw an arc whose plane is defined by a normal.
##
## The normal should be normalized.
##
func arc_normal(position: Vector3, normal: Vector3, angle_from: float, angle_to: float, radius: float = 1.0, draw_origin: bool = false, color: Color = current_color) -> void:
	if ! check_normalization(normal): return

	var basis = basis_from_normal(normal)
	basis = basis.scaled(Vector3(radius, radius, radius))
	arc(position, basis, angle_from, angle_to, draw_origin, color)


## Shortcut function to draw a cube whose orientation is defined by a normal.
##
## The normal should be normalized.
##
func cube_normal(position: Vector3, normal: Vector3, size: Vector3 = Vector3.ONE, color: Color = current_color) -> void:
	if ! check_normalization(normal): return

	var basis = basis_from_normal(normal)
	basis = basis.scaled(size)
	cube(position, basis, color)


## Shortcut function to draw an upright cube with no rotation.
func cube_up(position: Vector3 = Vector3.ZERO, size: Vector3 = Vector3.ONE, color: Color = current_color) -> void:
	var basis := Basis.IDENTITY.scaled(size)
	cube(position, basis, color)


################################
# SHORTCUTS - 2d drawing

func scale_basis(scale: float) -> Basis:
	return Basis.IDENTITY.scaled(Vector3(scale, scale, scale))


## Shortcut function to draw a circle lying on the XZ plane.
func circle_XZ(center: Vector3 = Vector3.ZERO, radius: float = 1.0, color: Color = current_color) -> void:
	var orientation = scale_basis(radius)
	circle(center, orientation, color)


## Shortcut function to draw a circle lying on the XY plane.
func circle_XY(center: Vector3 = Vector3.ZERO, radius: float = 1.0, color: Color = current_color) -> void:
	var orientation = scale_basis(radius)
	orientation = orientation.rotated(Vector3.RIGHT, TAU/4)
	circle(center, orientation, color)


## Shortcut function to draw an arc in the XY plane.
func arc_XY(center: Vector3, angle_from: float, angle_to: float, radius: float = 1.0, draw_origin = false, color: Color = current_color):
	arc(center, scale_basis(radius), angle_from, angle_to, draw_origin, color)
