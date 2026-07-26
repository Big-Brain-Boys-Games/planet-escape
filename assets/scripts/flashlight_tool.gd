extends Node3D

@onready var click_sound : AudioStreamPlayer = $AudioStreamPlayer

func do_action():
	click_sound.play()
	$"../../light".visible = !$"../../light".visible
