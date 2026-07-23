extends Node3D

@export var _air_bubble_prefab : PackedScene;
@export var _spawn_time = 15;
var _spawn_timer = 0

func _ready():
	_spawn_timer = randf_range(0, _spawn_time);

func _physics_process(delta: float) -> void:
	_spawn_timer -= delta
	
	if(_spawn_timer < 0):
		_spawn_timer = _spawn_time
		
		var new_bubble = _air_bubble_prefab.instantiate()
		get_parent().add_child(new_bubble)
		new_bubble.global_position = global_position + Vector3.UP * 0.5
