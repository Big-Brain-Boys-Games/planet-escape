extends Node3D

var size : Vector3
var height : float

func _ready():
	size = scale
	height = global_position.y
	global_position.y = 0
	scale *= 0.01

func _process(delta: float) -> void:
	scale = scale.move_toward(size, delta * size.y / 4.0)
	global_position.y = move_toward(global_position.y, height, delta*3)
