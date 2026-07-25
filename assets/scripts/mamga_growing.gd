extends Node3D

var size : Vector3

func _ready():
	size = scale
	scale *= 0.01

func _process(delta: float) -> void:
	scale = scale.move_toward(size, delta * size.y / 4.0)
