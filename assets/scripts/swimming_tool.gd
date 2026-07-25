extends Node3D

var is_active = false

var propellors : Node3D

var speed : float = 0
var velocity : Vector3 = Vector3.ZERO
@onready var propellor_hum : AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	propellors = get_node("propellors")
	
func do_action():
	is_active = !is_active

func _physics_process(delta: float) -> void:
	if (propellor_hum.stream_paused):
		propellor_hum.stream_paused = false
		
	if !visible:
		is_active = false
	
	if is_active:
		speed = move_toward(speed, 10, delta*5.5)
		propellor_hum.volume_linear = 0.2
	else:
		speed = move_toward(speed, 0, delta*5.5)
		propellor_hum.volume_linear = 0.0
	
	if visible:
		velocity = velocity.lerp(-$"../../..".global_basis.z * speed, delta)
		propellors.rotate_z(delta * speed*2.5)
		$"../../../..".velocity = $"../../../..".velocity.lerp(velocity, delta * velocity.length()/2.0)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta)
	
