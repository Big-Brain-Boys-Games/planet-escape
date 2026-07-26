extends AudioStreamPlayer3D

@export var sounds : Array[AudioStreamWAV]
@export var time_between_sound : float
var timer : Timer = Timer.new()

func _ready() -> void:
	timer.wait_time = time_between_sound
	timer.autostart = true
	timer.timeout.connect(_play_sound)
	add_child(timer)
	timer.start()
	

func _play_sound() -> void:
	stream = sounds.pick_random()
	play()
		
