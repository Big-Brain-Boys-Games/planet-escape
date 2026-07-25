extends Node3D

var last_rot : Quaternion
var own_rot : Quaternion

func _ready():
	last_rot = get_parent_node_3d().quaternion
	own_rot = quaternion

func _process(delta: float) -> void:
	var rot_diff = last_rot * get_parent_node_3d().quaternion.inverse()
	last_rot = get_parent_node_3d().quaternion
	quaternion *= rot_diff * 0.2
	quaternion = quaternion.slerp(own_rot, delta * 7)
