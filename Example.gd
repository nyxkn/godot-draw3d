tool
extends Spatial


const DEBUG: bool = false

# remember: variables will correctly use the default value on reload, but won't persist across reloads if changed
# although onready var assignments won't be reinitialized correctly

var d


export(bool) var reload = false setget _reload
func _reload(_value) -> void:
	if DEBUG: print("reloading")
	# hack to get code to run every time the script is reloaded after a filesave. put your code in setup() for clarity
	# discard the passed value; we don't care
	setup()


export(bool) var trigger = false setget on_trigger
func on_trigger(_value) -> void:
	if DEBUG: print("on_trigger")
	# hack to run manually triggered code
	# discard the passed value; we don't care
	pass


func _ready() -> void:
#	if DEBUG: print("ready")
	# don't add code in here. add your setup code in setup() and process code in _process() or _draw()
	_reload(true)
	
	
func setup() -> void:
	pass
#	d = find_node("Draw3D")
#	d.clear()
#	d.line_test()


func _process(delta: float) -> void:
#	d.clear()

	
	d.circle_XZ(Vector3(0, 0, 0))
	
#	d.circle_XY(Vector3(2, 0, 0))
#	d.circle_XZ(Vector3(4, 0, 0))

	var arcs = $Arcs/Draw3D
	arcs.circle(Vector3(6, 0, 0), Vector3(1, 0, 0))
	arcs.circle_normal(Vector3(1, 0, 1), Vector3(1, 1, 1).normalized(), 2.0)
	arcs.arc_normal(Vector3(-2, 2, 2), Vector3(1,1,1).normalized(), TAU/8, TAU/3, 1.0, false)
