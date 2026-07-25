extends HSlider

func _on_value_changed(new_value: float, audio : String) -> void:
	var bus_ID : int
	if (audio == "music"):
		bus_ID = 1
	if (audio == "SFX"):
		bus_ID = 2
	print(bus_ID)
	print(audio)
	AudioServer.set_bus_volume_linear(bus_ID,new_value)
