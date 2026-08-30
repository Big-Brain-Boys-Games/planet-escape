extends Node3D

var active : bool = false

var timer : float
@onready var area : Area3D = get_node("Area3D")
@onready var audio_player : AudioStreamPlayer = get_node("AudioStreamPlayer")

func do_action():
	active = !active

func _physics_process(delta: float) -> void:
	if(active):
		var bodies : Array[Node3D] = area.get_overlapping_bodies()
		var ores : Array[Node3D]
		for body in bodies:
			if (body.is_in_group("rock")):
				ores.append(body)
		if (ores.size() != 0):
			var ore = get_closest_body(ores)
			print(global_position.distance_to(ore.global_position))
			
			timer -= delta
			if (timer <= 0):
				audio_player.play(0)
				timer = global_position.distance_to(ore.global_position) / 10

func get_closest_body(bodies : Array[Node3D]) -> Node3D:
	var closest_body = bodies[0]
	if (bodies.size() == 0):
		return closest_body
	for body in bodies:
		if (global_position.distance_to(closest_body.global_position) > global_position.distance_to(body.global_position)):
			closest_body = body
	return closest_body
