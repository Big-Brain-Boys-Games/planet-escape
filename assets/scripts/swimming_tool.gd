extends Node3D

var is_active = false

var propellors : Node3D

var speed : float = 0
var velocity : Vector3 = Vector3.ZERO

func _ready():
	propellors = get_node("propellors")

func do_action():
	is_active = !is_active

func _physics_process(delta: float) -> void:
	if !visible:
		is_active = false
	
	if is_active:
		speed = move_toward(speed, 8, delta*3)
	else:
		speed = move_toward(speed, 0, delta*4)
	
	if visible:
		velocity = velocity.lerp(-$"../../..".global_basis.z * speed, delta)
		propellors.rotate_z(delta * speed*1.5)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta)
	
	$"../../../..".velocity = $"../../../..".velocity.lerp(velocity, delta * 5)
