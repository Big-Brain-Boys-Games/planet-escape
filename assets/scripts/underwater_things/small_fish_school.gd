extends Node3D

@export var small_fish : PackedScene
@export var amount : int = 5
@export var speed = 1

var targets : Array[Node3D]
var target : Vector3

func _ready() -> void:
	for i in range(1, get_child_count()):
		targets.append(get_child(i))
	
	target = targets[randi_range(0, targets.size()-1)].global_position + Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * 3
	
	#print("targets ", targets)
	
	for i in range(amount):
		add_child(small_fish.instantiate())

func _physics_process(delta: float) -> void:
	var diff : Vector3 = target - $fish_target.global_position
	$fish_target.global_translate(diff.normalized() * delta * speed)
	
	#print("target: ", target)
	#print("fish target: ", $fish_target.global_position)
	#print("distance ", diff.length_squared(), " to ", target)
	
	if diff.length_squared() < 5:
		target = targets[randi_range(0, targets.size()-1)].global_position + Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * 3
