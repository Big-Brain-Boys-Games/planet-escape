extends DirectionalLight3D

func _physics_process(delta: float) -> void:
	rotation.x += delta * delta
