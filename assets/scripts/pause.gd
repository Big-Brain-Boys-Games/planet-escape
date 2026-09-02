extends ColorRect

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("escape")):
		
		get_tree().paused = !get_tree().paused
		if (get_tree().paused):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		visible = get_tree().paused
