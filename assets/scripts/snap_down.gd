extends Node3D

func _ready():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position+Vector3.DOWN*20)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	#print(result)
	
	if "position" in result:
		global_position.y = result["position"].y
	else:
		queue_free()
	
	scale *= randf_range(0.5, 1.05)
