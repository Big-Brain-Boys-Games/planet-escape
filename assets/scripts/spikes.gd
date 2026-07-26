extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("player"):
		body.take_damage(20)
		body.velocity = global_position.direction_to(body.global_position) * 15
	pass # Replace with function body.
