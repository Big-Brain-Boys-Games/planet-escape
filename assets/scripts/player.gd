class_name Player
extends CharacterBody3D
## Implements the player controller.

## Player movement speed.
@export var speed : float = 2.0
@export var acceleration : float = 4.0
## Player camera (gets automatically set in _ready()).
@export var camera : Camera3D
@export var ray : RayCast3D
@export var collect_rock_label : Label
var current_rock : RigidBody3D
@export var mouse_speed : float = 0.2

@export var world_environment : Node;
@export var water_waves : Node3D;

@export var _air_reset : float = 75;
var _air_meter : float = _air_reset;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.use_accumulated_input = false
	ray = get_node("Camera3D/RayCast3D")
	collect_rock_label = get_tree().get_nodes_in_group("collect_rock_label")[0]
	for child in get_children():
		print(child)
		if(child.is_in_group("camera")):
			camera = child
			continue

func _physics_process(delta: float) -> void:
	if(global_position.y > water_waves.global_position.y-0.1):
		#above water
		world_environment.set_env(1)
		
		_air_meter = move_toward(_air_meter, _air_reset, delta*14)
		
		if(global_position.y > water_waves.global_position.y+0.2+sin(Time.get_ticks_msec()/1000.0)*0.3):
			global_position.y = water_waves.global_position.y+0.2+sin(Time.get_ticks_msec()/1000.0)*0.3
	else:
		#under water
		world_environment.set_env(0)
		_air_meter -= delta
		
	$Control/blackening.color.a = clamp(1-_air_meter/10.0, 0, 1);
	$Control/Air.text = "Air: " + str(_air_meter).pad_decimals(1)
	if(_air_meter > 10):
		$Control/Air.text = "Air: " + str(_air_meter).pad_decimals(0)
	
	#make water follow player
	water_waves.global_position.x = global_position.x;
	water_waves.global_position.z = global_position.z;
		
	
	# Movement code
	var direction : Vector3 = Vector3(0,0,0)
	#camera.rotation_degrees.z = 0
	# 1 is left, -1 is right
	var tilt : int = 0
	if (Input.is_action_pressed("forward")):
		direction -= camera.global_transform.basis.z.normalized()
	if (Input.is_action_pressed("backwards")):
		direction += camera.global_transform.basis.z.normalized()
	if (Input.is_action_pressed("left")):
		tilt = 1
		direction -= camera.global_transform.basis.x.normalized()
	if (Input.is_action_pressed("right")):
		tilt = -1
		direction += camera.global_transform.basis.x.normalized()
	if(Input.is_action_pressed("up")):
		direction += Vector3.UP; #camera.global_transform.basis.y.normalized()
	if(Input.is_action_pressed("down")):
		direction -= Vector3.UP; #camera.global_transform.basis.y.normalized()
	velocity = velocity.lerp(direction * speed + Vector3.UP*-0.2, 0.05)
	
	# Camera tilt
	var wanted_rotation : float = 0
	if(tilt == 1):
		wanted_rotation = 7
	if(tilt == -1):
		wanted_rotation = -7
	#if(direction == Vector3(0,0,0)):
		#camera.rotation_degrees.z = 0
	camera.rotation_degrees.z = lerpf(camera.rotation_degrees.z, wanted_rotation, 0.07)
	move_and_slide()

	# Check for rock and then set rock
	var collider : Object = ray.get_collider()
	if(is_instance_of(collider,RigidBody3D)):
		if (collider.is_in_group("rock")):
			current_rock = collider
			collect_rock_label.visible = true
	else:
		current_rock = null
		collect_rock_label.visible = false
		

func give_air(air : float):
	_air_meter += air
	_air_meter = min(_air_meter, _air_reset)

func _input(event: InputEvent) -> void:
		# Rotate the camera view
	if (event is InputEventMouseMotion):
		if(Input.mouse_mode != 0):
			#print(event.relative)
			var new_rot : float = camera.rotation_degrees.x + -event.screen_relative.y * mouse_speed
			if(new_rot < 90 && new_rot > -90):
				camera.rotation_degrees.x = new_rot
			camera.rotation_degrees.y += -event.screen_relative.x * mouse_speed
		return
	# Capture mouse if not captured and clicking the window
	if (event is InputEventMouseButton):
		if (event.pressed && event.button_index == 1):
			if(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
	
	# Escape mouse capture
	if (event.is_action_pressed("escape")):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Collect rock
	if(event.is_action_pressed("use")):
		if(collect_rock_label.visible):
			if(current_rock != null):
				current_rock.free()
