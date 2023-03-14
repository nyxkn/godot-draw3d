@tool

class_name Draw3D
extends MeshInstance3D

##
## A small library for drawing simple wireframe shapes in 3D.
##
## Usage is similar to Godot's
## [url=https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html]
## custom drawing in 2d[/url] functions.
##
## @tutorial: https://github.com/nyxkn/godot-draw3d/tree/main#usage
##

## Size in pixels of drawn points
const MATERIAL_POINT_SIZE: int = 8

## Resolution is the number of segments that will be used to draw a full circle.
## This also affects the resolution of semicircles and arcs.
@export var circle_resolution: int = 32

## Whether to also draw the vertices as points, in addition to lines.
@export var draw_vertex_points: bool = false

## This holds the default color value to use.
## It will be overridden by the specific draw functions [i]color[/i] parameter.
@export var default_color: Color = Color.WHITE


var _default_material: StandardMaterial3D
var _default_points_material: StandardMaterial3D


func _ready() -> void:
	mesh = ImmediateMesh.new()
	_setup_materials()


func _setup_materials() -> void:
	# here we are setting the material to material_override
	# which affects everything drawn within this mesh
	# but in godot4 it is actually possible to set the material per surface
	# a surface is a single drawing, created between surface_begin and surface_end
	# if we want to support this we need to add an optional material parameter to all functions
	# but the usefulness of this seems limited since we're drawing wireframe things anyway
	# and not many material parameters apply to these
	# plus it's easy to just make a new meshinstance instead if you need different material
	# we support this at least in _draw_primitive because why not

	_default_material = StandardMaterial3D.new()
	_default_material.vertex_color_use_as_albedo = true
	_default_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	_default_points_material = _default_material.duplicate()
	# enabling use_point_size replaces all lines with vertex points
	# this is different from godot3, where it only affected the points primitives
	# and not the line ones. is this a bug or intended?
	# we're working around this by having a different material for points surfaces
	_default_points_material.use_point_size = true
	_default_points_material.point_size = MATERIAL_POINT_SIZE


## Helper function that returns a random color.
static func random_color() -> Color:
	return Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))


## Clear all drawn content.
# If you are redrawing shapes every frame in _process(),
## you must call this at the beginning of the frame.
func clear() -> void:
	mesh.clear_surfaces()


func _points_test(clear: bool = false) -> void:
	if clear: clear()

	mesh.surface_begin(Mesh.PRIMITIVE_POINTS, null)
	for i in 100:
		mesh.surface_set_color(random_color())
		mesh.surface_add_vertex(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)))
	mesh.surface_end()


func _line_test(clear: bool = false) -> void:
	if clear: clear()

	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for i in 50:
		mesh.surface_set_color(random_color())
		mesh.surface_add_vertex(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)))
	mesh.surface_end()


################################################################################
# draw_primitive

## Draws a surface.
##
## [br][br][code]primitive_type[/code] is [enum Mesh.PrimitiveType].
##
## [br][br][code]vertices[/code] are supplied as an Array of Vector3 point coordinates.
## Or alternatively, as an Array of [i]colored vertices[/i],
## where a [i]colored vertex[/i] is an Array with two values, a vertex and a color:
## [code][vertex: Vector3, color: Color][/code].
## This allows you to have per-vertex coloring.
##
func _draw_primitive(
		primitive_type: int,
		vertices: Array,
		color: Color = default_color,
		custom_material: BaseMaterial3D = null) -> void:

	if vertices[0] is Vector3:
		# we're dealing with a list of vertices
		mesh.surface_begin(primitive_type, null)
		for v in vertices:
			mesh.surface_set_color(color)
			mesh.surface_add_vertex(v)
		mesh.surface_end()
	elif vertices[0] is Array:
		# we're dealing with a list of colored vertices
		# a colored vertex is [vertex, color]
		mesh.surface_begin(primitive_type, null)
		for i in vertices.size():
			mesh.surface_set_color(vertices[i][1])
			mesh.surface_add_vertex(vertices[i][0])
		mesh.surface_end()

	var material
	if custom_material:
		material = custom_material
	elif primitive_type == Mesh.PRIMITIVE_POINTS:
		material = _default_points_material
	else:
		material = _default_material

	var last_surface_idx = mesh.get_surface_count() - 1
	mesh.surface_set_material(last_surface_idx, material)


################################################################################
# draw_primitive shortcuts

## Draw points at the given vertices.
##
## [br][br]Vertices are supplied as an Array of Vector3 coordinates or as [i]colored vertices[/i].
## See [method _draw_primitive] for details.
##
func draw_points(vertices: Array, color: Color = default_color) -> void:
	_draw_primitive(Mesh.PRIMITIVE_POINTS, vertices, color)


## Draw line segments between the given vertices.
##
## [br][br]Vertices are supplied as an Array of Vector3 coordinates or as [i]colored vertices[/i].
## See [method _draw_primitive] for details.
##
func draw_line(vertices: Array, color: Color = default_color) -> void:
	_draw_primitive(Mesh.PRIMITIVE_LINE_STRIP, vertices, color)

	if draw_vertex_points:
		draw_points(vertices, color)


## Draw looping line segments between the given vertices.
## I.e. the last point connects back to the first.
##
## [br][br]Vertices are supplied as an Array of Vector3 coordinates or as [i]colored vertices[/i].
## See [method _draw_primitive] for details.
##
func draw_line_loop(vertices: Array, color: Color = default_color) -> void:
#	_draw_primitive(Mesh.PRIMITIVE_LINE_LOOP, vertices, color)
	var looped_vertices = vertices.duplicate()
	looped_vertices.push_back(vertices[0])
	draw_line(looped_vertices, color)

	if draw_vertex_points:
		draw_points(vertices, color)


################################
# CIRCLE

## Generic function to draw a circle.
##
## [br][br]Pass a Basis parameter to define orientation.
## Otherwise defaults to lying on the XZ plane.
##
func circle(position: Vector3 = Vector3.ZERO,
		basis: Basis = Basis.IDENTITY, color: Color = default_color) -> void:
	# by default, this is a circle on the XZ plane.
	# this seems to make most sense in 3d as a highlight of objects

	var resolution = circle_resolution
	var transform = Transform3D(basis, position)

	var circle = []
	for i in resolution:
		var angle = TAU / resolution * i
		var angle_vector = Vector3(cos(angle), 0, sin(angle))
		angle_vector = transform * angle_vector
		circle.append(angle_vector)

	draw_line_loop(circle, color)


###############################
# ARC

func _compute_arc(angle_from: float, angle_to: float,
		transform: Transform3D = Transform3D.IDENTITY) -> PackedVector3Array:
	# angles in radians, obviously

	var arc2 = PackedVector2Array()

	var angle_total = angle_to - angle_from
	if angle_total > TAU:
		print("Angle is > TAU. We won't draw.")
		return PackedVector3Array()

	var resolution = lerp(1, circle_resolution + 1, angle_total / TAU)

	for i in resolution:
		var t = i / float(resolution - 1) # include the last point
		var angle = lerp(angle_from, angle_to, t)
		var angle_vector = Vector2(cos(angle), sin(angle))
		arc2.push_back(angle_vector)

	# convert to 3d
	var arc3 = PackedVector3Array()
	for p in arc2:
		arc3.push_back(Vector3(p.x, p.y, 0))

	# apply 3d transform
	for i in arc3.size():
		arc3[i] = transform * arc3[i]

	return arc3


## Generic function to draw an arc.
##
## [br][br]Pass a Basis parameter to define orientation.
##
## [br][br][code]angle_from[/code] and [code]angle_to[/code] are in radians.
##
## [br][br]If [code]draw_origin[/code] is true, also draw the origin point
## and connect it with two lines on each end (a circular sector).
##
func arc(position: Vector3, basis: Basis, angle_from: float, angle_to: float,
		draw_origin: bool = false, color: Color = default_color) -> void:

	var arc: PackedVector3Array
	var transform = Transform3D(basis, position)

	if draw_origin:
		arc = PackedVector3Array()
		arc.push_back(transform * Vector3.ZERO)
		arc.append_array(_compute_arc(angle_from, angle_to, transform))
		draw_line_loop(arc, color)
	else:
		arc = _compute_arc(angle_from, angle_to, transform)
		draw_line(arc, color)


################################
# CUBE - wireframe cube

## Generic function to draw a cube.
##
## [br][br]Pass a Basis parameter to define orientation.
## Otherwise defaults to no orientation.
##
func cube(position: Vector3 = Vector3.ZERO, basis: Basis = Basis.IDENTITY,
		color: Color = default_color) -> void:

	# https://www.khronos.org/opengl/wiki/Primitive
	var vertices := [
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

	var transform = Transform3D(basis, position)

	for i in vertices.size():
		vertices[i] = transform * vertices[i]

	draw_line_loop(vertices.slice(0, 4), color)
	draw_line_loop(vertices.slice(4, 8), color)
	for i in 4:
		draw_line([vertices[i], vertices[i+4]], color)


################################
# SPHERE - wireframe sphere

## Create a sphere shape.
##
## This does not take a position vector, so it will always be drawn at (0, 0, 0)
##
## It's best to draw the sphere on a dedicated Draw3D node so you can manipulate it by adjusting the
## transform properties.
##
#func sphere(radius: float = 1.0, color: Color = default_color,
#		lats: int = 16, lons: int = 16, add_uv: bool = true) -> void:
#	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, null)
#	mesh.surface_set_color(color)
#	add_sphere(lats, lons, radius, add_uv)
#	mesh.surface_end()


################################
# SHORTCUTS - from normal

func _basis_from_normal(normal: Vector3) -> Basis:
	# technically don't need to normalize again since we're already checking. but just in case.
	var Y = normal.normalized()
	var X = Vector3(Y.y, -Y.x, 0)
	# covering the edge case where our normal is (0, 0, 1)
	if X.length_squared() == 0: X = Vector3(-1, 0, 0)

	var Z = X.cross(Y)
	return Basis(X, Y, Z)


func _ensure_normalized(normal: Vector3) -> bool:
	# the normal should be normalized
	# we could normalize silently but it's good to double check with the user -
	# to make sure that they're sending the right data
	if normal.is_normalized() == false:
		print("Normal vector should be normalized. We won't draw.")
		return false

	return true


## Shortcut function to draw a circle whose plane is defined by a normal.
##
## [br][br][code]normal[/code] should be normalized.
##
func circle_normal(position: Vector3, normal: Vector3, radius: float = 1.0,
		color: Color = default_color) -> void:

	if ! _ensure_normalized(normal): return

	var basis = _basis_from_normal(normal)
	basis = basis.scaled(Vector3(radius, radius, radius))
	circle(position, basis, color)


## Shortcut function to draw an arc whose plane is defined by a normal.
##
## [br][br][code]normal[/code] should be normalized.
##
func arc_normal(position: Vector3, normal: Vector3, angle_from: float, angle_to: float,
		radius: float = 1.0, draw_origin: bool = false, color: Color = default_color) -> void:

	if ! _ensure_normalized(normal): return

	var basis = _basis_from_normal(normal)
	basis = basis.scaled(Vector3(radius, radius, radius))
	arc(position, basis, angle_from, angle_to, draw_origin, color)


## Shortcut function to draw a cube whose orientation is defined by a normal.
##
## [br][br][code]normal[/code] should be normalized.
##
func cube_normal(position: Vector3, normal: Vector3, size: Vector3 = Vector3.ONE,
		color: Color = default_color) -> void:

	if ! _ensure_normalized(normal): return

	var basis = _basis_from_normal(normal)
	basis = basis.scaled(size)
	cube(position, basis, color)


## Shortcut function to draw an upright cube with no rotation.
func cube_up(position: Vector3 = Vector3.ZERO, size: Vector3 = Vector3.ONE,
		color: Color = default_color) -> void:

	var basis := Basis.IDENTITY.scaled(size)
	cube(position, basis, color)


################################
# SHORTCUTS - 2d drawing

func _scale_basis(scale: float) -> Basis:
	return Basis.IDENTITY.scaled(Vector3(scale, scale, scale))


## Shortcut function to draw a circle lying on the XZ plane.
func circle_XZ(center: Vector3 = Vector3.ZERO, radius: float = 1.0,
		color: Color = default_color) -> void:

	var orientation = _scale_basis(radius)
	circle(center, orientation, color)


## Shortcut function to draw a circle lying on the XY plane.
func circle_XY(center: Vector3 = Vector3.ZERO, radius: float = 1.0,
		color: Color = default_color) -> void:

	var orientation = _scale_basis(radius)
	orientation = orientation.rotated(Vector3.RIGHT, TAU/4)
	circle(center, orientation, color)


## Shortcut function to draw an arc in the XY plane.
func arc_XY(center: Vector3, angle_from: float, angle_to: float,
		radius: float = 1.0, draw_origin = false, color: Color = default_color):

	arc(center, _scale_basis(radius), angle_from, angle_to, draw_origin, color)
