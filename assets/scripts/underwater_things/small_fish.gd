extends Node3D

@export var speed : float = 1.5
@export var rotating : float = 2
@export var target_area : float = 1

func set_target():
	$target.global_position = get_parent().get_node("fish_target").global_position + Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)) * 2

func _ready() -> void:
	set_target()

var rot_vel = Quaternion.from_euler(Vector3(0,0,0))

func _process(delta: float) -> void:
	var rot = quaternion
	look_at($target.global_position)
	quaternion = rot.slerp(quaternion, delta*rotating)
	#var rot_diff = quaternion * rot.inverse()
	#rot_vel = rot_vel.slerp(rot_diff, delta)
	#quaternion = rot * rot_vel
	
	#print("target : ", $target.global_position)
	#print("fish : ", global_position)
	
	var diff : Vector3 = $target.global_position - global_position;
	#print("direction: ", diff.normalized() )
	global_translate(-global_basis.z * delta * speed)
	
	if diff.length_squared() < target_area:
		set_target()
