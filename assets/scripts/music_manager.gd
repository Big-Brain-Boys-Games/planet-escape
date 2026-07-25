class_name MusicManager
extends AudioStreamPlayer

var music_transition_time : float = 5

var old_music_transition : float
var new_music_transition : float

var new_song : AudioStream

func change_music(music : AudioStream) -> void:
	old_music_transition = music_transition_time
	new_music_transition = 0
	new_song = music
	
func _process(delta: float) -> void:
	if (old_music_transition > 0):
		volume_linear = old_music_transition / music_transition_time
		print(old_music_transition / music_transition_time)
		old_music_transition -= delta
		if (old_music_transition <= 0):
			stream = new_song
			play()
			
	elif (new_music_transition < music_transition_time):
		volume_linear = new_music_transition / music_transition_time
		new_music_transition += delta
