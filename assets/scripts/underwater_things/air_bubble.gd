extends Node3D

@export var _alive_timer = 15;

func _physics_process(delta: float) -> void:
	global_position.y += delta*3;
	
	_alive_timer -= delta
	if(_alive_timer < 3):
		scale = Vector3.ONE * _alive_timer / 3.0
		if(_alive_timer < 0):
			queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	#todo: something here
	
	if(body.is_in_group("player")):
		body.give_air(20)
		queue_free();
	pass # Replace with function body.
