extends Node3D

var timer : float
var current_rock : Ore.Ores = Ore.Ores.INVALID
@onready var area : Area3D = get_node("Area3D")
@onready var audio_player : AudioStreamPlayer = get_node("AudioStreamPlayer")

func do_action() -> void:
	cycle_action()

func _physics_process(delta: float) -> void:
	if(current_rock != Ore.Ores.INVALID):
		var bodies : Array[Node3D] = area.get_overlapping_bodies()
		var ores : Array[Node3D]
		for body in bodies:
			if (body.is_in_group("rock")):
				if(body.oretype == current_rock):
					ores.append(body)
		if (ores.size() != 0):
			var ore = get_closest_body(ores)
			print(global_position.distance_to(ore.global_position))
			
			timer -= delta
			if (timer <= 0):
				audio_player.play(0)
				timer = global_position.distance_to(ore.global_position) / 20

func get_closest_body(bodies : Array[Node3D]) -> Node3D:
	var closest_body = bodies[0]
	if (bodies.size() == 0):
		return closest_body
	for body in bodies:
		if (global_position.distance_to(closest_body.global_position) > global_position.distance_to(body.global_position)):
			closest_body = body
	return closest_body

func cycle_action() -> void:
	if(current_rock == Ore.Ores.size() - 1):
		current_rock = Ore.Ores.INVALID
	else:
		current_rock += 1
