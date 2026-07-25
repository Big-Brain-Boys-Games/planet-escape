extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if not visible:
		return
	
	if body.is_in_group("player"):
		body.die()
	pass # Replace with function body.
