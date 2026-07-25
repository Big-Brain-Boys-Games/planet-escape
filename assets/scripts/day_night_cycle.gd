extends DirectionalLight3D

@export var dont_affect_night : bool = false
var night_time : float

func _physics_process(delta: float) -> void:
	rotation.x += delta*0.016
	
	if (!dont_affect_night):
		night_time = 0.5 - global_basis.z.dot(Vector3.UP) / 2
	else:
		if (night_time <= 1.03):
			night_time += delta * 0.1
	RenderingServer.global_shader_parameter_set("night_time", night_time)
	RenderingServer.global_shader_parameter_set("sky_color", Color(Color(0.424, 0.584, 0.808)).lerp(Color(0.147, 0.132, 0.176, 1.0), night_time))
		
