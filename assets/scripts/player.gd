class_name Player
extends CharacterBody3D
## Implements the player controller.

## Player movement speed.
@export var speed : float = 5.0
@export var acceleration : float = 4.0
## Player camera (gets automatically set in _ready()).
@export var camera : Camera3D
@export var mouse_speed : float = 1.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for child in get_children():
		if(child.is_in_group("camera")):
			camera = child
			continue

func _physics_process(delta: float) -> void:
	var direction : Vector3 = Vector3(0,0,0)
	camera.rotation_degrees.z = 0
	#1 is left, -1 is right
	var tilt : int = 0
	if (Input.is_action_pressed("forward")):
		direction += -camera.global_transform.basis.z.normalized()
	if (Input.is_action_pressed("backwards")):
		direction += camera.global_transform.basis.z.normalized()
	if (Input.is_action_pressed("left")):
		tilt = 1
		direction += -camera.global_transform.basis.x.normalized()
	if (Input.is_action_pressed("right")):
		tilt = -1
		direction += camera.global_transform.basis.x.normalized()
	if(Input.is_action_pressed("up")):
		direction.y += 1
	if(Input.is_action_pressed("down")):
		direction.y -= 1
	velocity = direction * speed
	if(tilt == 1):
		camera.rotation_degrees.z = 0
	if(tilt == -1):
		camera.rotation_degrees.z = -0
	if(direction == Vector3(0,0,0)):
		camera.rotation_degrees.z = 0
	move_and_slide()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == 1):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if (event is InputEventMouseMotion):
		if(Input.mouse_mode != 0):
			var new_rot : float = camera.rotation_degrees.x + -event.relative.y * mouse_speed
			if(new_rot < 90 && new_rot > -90):
				camera.rotation_degrees.x = new_rot
			camera.rotation_degrees.y += -event.relative.x * mouse_speed
	if (event.is_action_pressed("escape")):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
