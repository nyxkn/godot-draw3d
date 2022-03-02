# Draw3D

 A small library for drawing simple shapes in 3D.

 Usage is similar to the custom drawing in 2D that is already present in Godot:

 https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html



**Extends**: `ImmediateGeometry`

**Icon**: ![icon](/addons/CanvasItem.svg)

## Table of contents

### Constants

|Name|Type|Default|
|:-|:-|:-|
|[COLOR_DEFAULT](#color_default)|`Color`|`Color.white`|

### Variables

|Name|Type|Default|
|:-|:-|:-|
|[circle_resolution](#circle_resolution)|`int`|`32`|

### Functions

|Name|Type|Default|
|:-|:-|:-|
|[change_point_size](#change_point_size)|`int`|-|
|[change_line_width](#change_line_width)|`int`|-|
|[points](#points)|`Array`|-|
|[line](#line)|`Array`|-|
|[line_loop](#line_loop)|`Array`|-|
|[points_colored](#points_colored)|`Array`|-|
|[line_colored](#line_colored)|`Array`|-|
|[circle](#circle)|`Vector3`|-|
|[cube](#cube)|`Vector3`|-|
|[cube_normal](#cube_normal)|`Vector3`|-|
|[cube_up](#cube_up)|`Vector3`|-|
|[circle_XZ](#circle_xz)|`Vector3`|-|
|[circle_XY](#circle_xy)|`Vector3`|-|

## Constants

### COLOR_DEFAULT

```gdscript
const COLOR_DEFAULT: Color = Color.white
```

Default color to use for all the drawings.

|Name|Type|Default|
|:-|:-|:-|
|`COLOR_DEFAULT`|`Color`|`Color.white`|

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

## Functions

### change_point_size

```gdscript
func change_point_size(size: int) -> void
```

Change point size.

 This applies to all points currently and previously drawn.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`size`|`int`|-|

### change_line_width

```gdscript
func change_line_width(width: int) -> void
```

Change line width.

 Currently unimplemented in Godot.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`width`|`int`|-|

### points

```gdscript
func points(vertices: Array, color: Color = current_color) -> void
```

Draw points from an Array of Vector3 vertices.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`vertices`|`Array`|-|
|`color`|`Color`|`current_color`|

### line

```gdscript
func line(vertices: Array, color: Color = current_color) -> void
```

Draw line segments from an Array of Vector3 vertices.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`vertices`|`Array`|-|
|`color`|`Color`|`current_color`|

### line_loop

```gdscript
func line_loop(vertices: Array, color: Color = current_color) -> void
```

Draw looping line segments from an Array of Vector3 vertices.

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
func circle(position: Vector3, basis: Basis = Basis.IDENTITY, color: Color = current_color) -> void
```

Generic function to draw a circle.

 Pass a Basis argument to define orientation.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`basis`|`Basis`|`Basis.IDENTITY`|
|`color`|`Color`|`current_color`|

### arc

```gdscript
func arc(position: Vector3, basis: Basis, angle_from: float, angle_to: float
```

Generic function to draw an arc.

 Pass a Basis argument to define orientation.

 Angle_from and Angle_to are in radians.

 Optionally also draw the origin point and connect it with two lines on each end (a circular sector).



### cube

```gdscript
func cube(position: Vector3, basis: Basis = Basis.IDENTITY) -> void
```

Generic function to draw a cube.

 Pass a Basis argument to define orientation.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`basis`|`Basis`|`Basis.IDENTITY`|

### create_sphere

```gdscript
func create_sphere(radius: float = 1.0, color: Color = current_color
```

Create a sphere shape.

 This function returns an ImmediateGeometry node that you need to manually add to the scene with add_child.



### circle_normal

```gdscript
func circle_normal(position: Vector3, normal: Vector3, radius: float = 1.0
```

Shortcut function to draw a circle whose plane is defined by a normal.

 The normal should be normalized.



### arc_normal

```gdscript
func arc_normal(position: Vector3, normal: Vector3, angle_from: float, angle_to: float
```

Shortcut function to draw an arc whose plane is defined by a normal.

 The normal should be normalized.



### cube_normal

```gdscript
func cube_normal(position: Vector3, normal: Vector3, size: Vector3 = Vector3.ONE) -> void
```

Shortcut function to draw a cube whose orientation is defined by a normal.

 The normal should be normalized.



#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`normal`|`Vector3`|-|
|`size`|`Vector3`|`Vector3.ONE`|

### cube_up

```gdscript
func cube_up(position: Vector3, size: Vector3 = Vector3.ONE) -> void
```

Shortcut function to draw an upright cube with no rotation.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`position`|`Vector3`|-|
|`size`|`Vector3`|`Vector3.ONE`|

### circle_XZ

```gdscript
func circle_XZ(center: Vector3, radius: float = 1.0, color: Color = current_color) -> void
```

Shortcut function to draw a circle lying on the XZ plane.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`center`|`Vector3`|-|
|`radius`|`float`|`1.0`|
|`color`|`Color`|`current_color`|

### circle_XY

```gdscript
func circle_XY(center: Vector3, radius: float = 1.0, color: Color = current_color) -> void
```

Shortcut function to draw a circle lying on the XY plane.

#### Parameters

|Name|Type|Default|
|:-|:-|:-|
|`center`|`Vector3`|-|
|`radius`|`float`|`1.0`|
|`color`|`Color`|`current_color`|

### arc_2d

```gdscript
func arc_2d(center: Vector3, angle_from: float, angle_to: float, radius: float = 1.0
```

Shortcut function to draw an arc in the XY plane.

---

Powered by [GDScriptify](https://github.com/hiulit/GDScriptify).
