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
	Input.mouse_mode = 2
	for child in get_children():
		if(child.is_in_group("camera")):
			camera = child
			continue

func _physics_process(delta: float) -> void:
	var direction : Vector3
	if (Input.is_action_pressed("forward")):
		direction += -camera.global_transform.basis.z.normalized()
	if (Input.is_action_pressed("backwards")):
		direction += camera.global_transform.basis.z.normalized()
	if (Input.is_action_pressed("left")):
		direction += -camera.global_transform.basis.x.normalized()
	if (Input.is_action_pressed("right")):
		direction += camera.global_transform.basis.x.normalized()
	if(Input.is_action_pressed("up")):
		direction.y += 1
	if(Input.is_action_pressed("down")):
		direction.y -= 1
	print(direction)
	velocity = direction * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		var new_rot : float = camera.rotation_degrees.x + -event.relative.y * mouse_speed
		if(new_rot < 90 && new_rot > -90):
			camera.rotation_degrees.x = new_rot
		camera.rotation_degrees.y += -event.relative.x * mouse_speed
