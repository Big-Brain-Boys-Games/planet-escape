extends Node3D

func _process(delta: float) -> void:
	$Cylinder.rotate_x(-delta)
	$Cylinder_001.rotate_x(delta)
