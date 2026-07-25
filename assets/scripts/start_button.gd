extends Button

@export var scene : String;
var _fade_out : float = 2
var _loading = false;

func _process(delta: float) -> void:
	#print("loading ", _loading)
	if _loading:
		if _fade_out > 0:
			$"../fadeout".color.a = 1-_fade_out/2.0
			_fade_out -= delta
			if _fade_out < 0:
				get_tree().change_scene_to_file(scene);
				GameManager.world_state = GameManager.States.WAKEUP

func _on_pressed() -> void:
	print("button pressed")
	_loading = true
	pass # Replace with function body.
