extends Node3D

var vel : Vector3
var rot_vel : Vector3

func _ready():
	vel = Vector3(randf_range(-1,1), -6, randf_range(-1, 1)).normalized() * randf_range(10, 20)
	rot_vel = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized()
	#scale_object_local(Vector3(1.0/global_transform.basis.x.length(), 1.0/global_transform.basis.y.length(), 1.0/global_transform.basis.z.length()) * 0.7)

func _physics_process(delta: float) -> void:
	global_position += vel * delta
	
	if global_position.y > 125:
		global_position += vel * delta * 2
	
	rotate(rot_vel, delta)
	
	if global_position.y < 80:
		queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("player"):
		body.take_damage(40)
		body.velocity = ((body.global_position-global_position).normalized() * Vector3(1, 0.01, 1)).normalized() * 40
	else:
		queue_free()
	pass # Replace with function body.
