# Draw3D

 A small library for drawing simple shapes in 3D.

 Usage is similar to the custom drawing in 2D that is already present in Godot:

 https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html



**Extends**: `ImmediateGeometry`

**Icon**: ![icon](/addons/CanvasItem.svg)

## Table of contents

### Variables

|Name|Type|Default|
|:-|:-|:-|
|[circle_resolution](#circle_resolution)|`int`|`32`|
|[current_color](#current_color)|`Color`|`COLOR_DEFAULT`|

### Functions

|Name|Type|Default|
|:-|:-|:-|
|[change_point_size](#change_point_size)|`int`|`POINT_SIZE_DEFAULT`|
|[change_line_width](#change_line_width)|`int`|`LINE_WIDTH_DEFAULT`|
|[change_color](#change_color)|`Color`|`COLOR_DEFAULT`|
|[points](#points)|`Array`|-|
|[line](#line)|`Array`|-|
|[line_loop](#line_loop)|`Array`|-|
|[points_colored](#points_colored)|`Array`|-|
|[line_colored](#line_colored)|`Array`|-|
|[circle](#circle)|`Vector3`|`Vector3.ZERO`|
|[arc](#arc)|`Vector3`|-|
|[cube](#cube)|`Vector3`|`Vector3.ZERO`|
|[sphere](#sphere)|`float`|`1.0`|
|[circle_normal](#circle_normal)|`Vector3`|-|
|[arc_normal](#arc_normal)|`Vector3`|-|
|[cube_normal](#cube_normal)|`Vector3`|-|
|[cube_up](#cube_up)|`Vector3`|`Vector3.ZERO`|
|[circle_XZ](#circle_xz)|`Vector3`|`Vector3.ZERO`|
|[circle_XY](#circle_xy)|`Vector3`|`Vector3.ZERO`|
|[arc_XY](#arc_xy)|`Vector3`|-|

## Variables

### circle_resolution

```gdscript
export(int) var circle_resolution: int = 32
```

Number of segments that will be used to draw a circle.

 Also applies for the resolution of arcs.



|Name|Type|Default|
|:-|:-|:-|
|`circle_resolution`|`int`|`32`|

### current_color

```gdscript
var current_color: Color = COLOR_DEFAULT setget change_color
```

This holds the color value to use unless overridden by the specific draw functions.

 Change this with change_color().



|Name|Type|Default|Setter|
|:-|:-|:-|:-|
|`current_color`|`Color`|`COLOR_DEFAULT`|`change_color`|

## Functions

### change_point_size

```gdscript
func change_point_size(size: int = POINT_SIZE_DEFAULT) -> void
```

Change point size.

 This applies to all points currently and previously drawn.

 Call without arguments to reset to the default size.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`size`|`int`|`POINT_SIZE_DEFAULT`|

### change_line_width

```gdscript
func change_line_width(width: int = LINE_WIDTH_DEFAULT) -> void
```

Change line width.

 Call without arguments to reset to the default width.


*This is currently unimplemented in Godot and has no effect.*



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`width`|`int`|`LINE_WIDTH_DEFAULT`|

### change_color

```gdscript
func change_color(color: Color = COLOR_DEFAULT) -> void
```

Change default color for all subsequent draws.

 Call without arguments to reset to the default color.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`color`|`Color`|`COLOR_DEFAULT`|

### random_color

```gdscript
func random_color() -> Color
```

Helper function that returns a random color.

**Returns**: `Color`

### points

```gdscript
func points(vertices: Array, color: Color = current_color) -> void
```

Draw points at the given vertices. Vertices are supplied as an Array of Vector3 coordinates.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`vertices`|`Array`|-|
|`color`|`Color`|`current_color`|

### line

```gdscript
func line(vertices: Array, color: Color = current_color) -> void
```

Draw line segments between the given vertices. Vertices are supplied as an Array of Vector3 coordinates.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`vertices`|`Array`|-|
|`color`|`Color`|`current_color`|

### line_loop

```gdscript
func line_loop(vertices: Array, color: Color = current_color) -> void
```

Draw looping line segments between the given vertices. I.e. the last point connects back to the first. Vertices are supplied as an Array of Vector3 coordinates.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`vertices`|`Array`|-|
|`color`|`Color`|`current_color`|

### points_colored

```gdscript
func points_colored(colored_vertices: Array) -> void
```

Draw points from an Array of *colored vertices*.

 A *colored vertex* is an Array with a Vector3 vertex and a Color value:

 `[ vertex: Vector3, color: Color ]`

 This allows you to draw points with individual colors.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`colored_vertices`|`Array`|-|

### line_colored

```gdscript
func line_colored(colored_vertices: Array) -> void
```

Draw line segments from an Array of *colored vertices*.

 A *colored vertex* is an Array with a Vector3 vertex and a Color value:

 `[ vertex: Vector3, color: Color ]`

 This allows you to draw line segments that blend between the colors of the two surrounding vertices.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`colored_vertices`|`Array`|-|

### circle

```gdscript
func circle(position: Vector3 = Vector3.ZERO, basis: Basis = Basis.IDENTITY, color: Color = current_color) -> void
```

Generic function to draw a circle.

 Pass a Basis argument to define orientation. Otherwise defaults to lying on the XZ plane.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|`Vector3.ZERO`|
|`basis`|`Basis`|`Basis.IDENTITY`|
|`color`|`Color`|`current_color`|

### arc

```gdscript
func arc(position: Vector3, basis: Basis, angle_from: float, angle_to: float, draw_origin: bool = false, color: Color = current_color)
```

Generic function to draw an arc.

 Pass a Basis argument to define orientation.

 Angle_from and Angle_to are in radians.

 Optionally also draw the origin point and connect it with two lines on each end (a circular sector).



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`basis`|`Basis`|-|
|`angle_from`|`float`|-|
|`angle_to`|`float`|-|
|`draw_origin`|`bool`|`false`|
|`color`|`Color`|`current_color`|

### cube

```gdscript
func cube(position: Vector3 = Vector3.ZERO, basis: Basis = Basis.IDENTITY, color: Color = current_color) -> void
```

Generic function to draw a cube.

 Pass a Basis argument to define orientation. Otherwise defaults to no orientation.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|`Vector3.ZERO`|
|`basis`|`Basis`|`Basis.IDENTITY`|
|`color`|`Color`|`current_color`|

### sphere

```gdscript
func sphere(radius: float = 1.0, color: Color = current_color, lats: int = 16, lons: int = 16, add_uv: bool = true) -> void
```

Create a sphere shape.

 This does not take a position vector, so it will always be drawn at (0, 0, 0)

 It's best to draw the sphere on a dedicated Draw3D node so you can manipulate it by adjusting the transform properties.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`radius`|`float`|`1.0`|
|`color`|`Color`|`current_color`|
|`lats`|`int`|`16`|
|`lons`|`int`|`16`|
|`add_uv`|`bool`|`true`|

### circle_normal

```gdscript
func circle_normal(position: Vector3, normal: Vector3, radius: float = 1.0, color: Color = current_color) -> void
```

Shortcut function to draw a circle whose plane is defined by a normal.

 The normal should be normalized.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`normal`|`Vector3`|-|
|`radius`|`float`|`1.0`|
|`color`|`Color`|`current_color`|

### arc_normal

```gdscript
func arc_normal(position: Vector3, normal: Vector3, angle_from: float, angle_to: float, radius: float = 1.0, draw_origin: bool = false, color: Color = current_color) -> void
```

Shortcut function to draw an arc whose plane is defined by a normal.

 The normal should be normalized.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`normal`|`Vector3`|-|
|`angle_from`|`float`|-|
|`angle_to`|`float`|-|
|`radius`|`float`|`1.0`|
|`draw_origin`|`bool`|`false`|
|`color`|`Color`|`current_color`|

### cube_normal

```gdscript
func cube_normal(position: Vector3, normal: Vector3, size: Vector3 = Vector3.ONE, color: Color = current_color) -> void
```

Shortcut function to draw a cube whose orientation is defined by a normal.

 The normal should be normalized.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`normal`|`Vector3`|-|
|`size`|`Vector3`|`Vector3.ONE`|
|`color`|`Color`|`current_color`|

### cube_up

```gdscript
func cube_up(position: Vector3 = Vector3.ZERO, size: Vector3 = Vector3.ONE, color: Color = current_color) -> void
```

Shortcut function to draw an upright cube with no rotation.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|`Vector3.ZERO`|
|`size`|`Vector3`|`Vector3.ONE`|
|`color`|`Color`|`current_color`|

### circle_XZ

```gdscript
func circle_XZ(center: Vector3 = Vector3.ZERO, radius: float = 1.0, color: Color = current_color) -> void
```

Shortcut function to draw a circle lying on the XZ plane.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`center`|`Vector3`|`Vector3.ZERO`|
|`radius`|`float`|`1.0`|
|`color`|`Color`|`current_color`|

### circle_XY

```gdscript
func circle_XY(center: Vector3 = Vector3.ZERO, radius: float = 1.0, color: Color = current_color) -> void
```

Shortcut function to draw a circle lying on the XY plane.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`center`|`Vector3`|`Vector3.ZERO`|
|`radius`|`float`|`1.0`|
|`color`|`Color`|`current_color`|

### arc_XY

```gdscript
func arc_XY(center: Vector3, angle_from: float, angle_to: float, radius: float = 1.0, draw_origin = false, color: Color = current_color)
```

Shortcut function to draw an arc in the XY plane.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`center`|`Vector3`|-|
|`angle_from`|`float`|-|
|`angle_to`|`float`|-|
|`radius`|`float`|`1.0`|
|`draw_origin `|-|`false`|
|`color`|`Color`|`current_color`|

---

Powered by [GDScriptify](https://github.com/hiulit/GDScriptify).
