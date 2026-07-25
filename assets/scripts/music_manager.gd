class_name MusicManager
extends AudioStreamPlayer

var music_out_time : float
var music_in_time : float

var old_music_transition : float
var new_music_transition : float

var new_song : AudioStream

func change_music(music : AudioStream, fade_out_duration : float, fade_in_duration : float) -> void:
	music_out_time = fade_out_duration
	music_in_time = fade_in_duration

	old_music_transition = fade_out_duration
	new_music_transition = 0
	new_song = music
	
func _process(delta: float) -> void:
	if (old_music_transition > 0):
		volume_linear = old_music_transition / music_out_time
		print(old_music_transition / music_out_time)
		old_music_transition -= delta
		if (old_music_transition <= 0):
			stream = new_song
			play()
			
	elif (new_music_transition < music_in_time):
		volume_linear = new_music_transition / music_in_time
		new_music_transition += delta
