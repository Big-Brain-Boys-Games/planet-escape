class_name notification
extends RichTextLabel

@export var timer : float = 5
var timer_running : bool = false
var current_timer : float = 0

func play_notification(new_text : String) -> void:
	current_timer = timer
	timer_running = true
	get_parent().get_parent().get_parent().modulate = Color(1,1,1,1)
	text = new_text
	
func _process(delta: float) -> void:
	if (current_timer > 0):
		current_timer -= delta
	if(timer_running && current_timer <= 0):
		timer_running = false
		get_parent().get_parent().get_parent().modulate = Color(1,1,1,0)
