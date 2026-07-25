extends DirectionalLight3D

func _physics_process(delta: float) -> void:
	rotation.x += delta*0.016
	
	var night_time = 0.5 - global_basis.z.dot(Vector3.UP) / 2
	RenderingServer.global_shader_parameter_set("night_time", night_time)
	RenderingServer.global_shader_parameter_set("sky_color", Color(Color(0.424, 0.584, 0.808)).lerp(Color(0.147, 0.132, 0.176, 1.0), night_time))
