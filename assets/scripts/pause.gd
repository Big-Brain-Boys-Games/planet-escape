extends ColorRect

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("escape")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = !get_tree().paused
		print("paused: ", get_tree().paused)
		visible = get_tree().paused
