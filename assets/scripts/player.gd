class_name Player
extends CharacterBody3D
## Implements the player controller.

## Player movement speed.
@export var speed : float = 2.6
@export var acceleration : float = 4.0
## Player camera (gets automatically set in _ready()).
@export var camera : Camera3D
@export var ray : RayCast3D
@export var interact_label : Label
@export var notification_node : notification
var current_rock : Ore
var interacting_with : String
@export var mouse_speed : float = 0.2
var inventory : Inventory

var player_movement_enabled : bool = true
var camera_movement_enabled : bool = true

var camera_shake : float = 0

@export var camera_attributes : Array[CameraAttributes];

@export var world_environment : Node;
@export var water_waves : Node3D;

@export var _air_reset : float = 75;
var _air_meter : float = _air_reset;

@export var waves_heightmap : Image;
@export var planet_exploding_timer : float = 60*3

var _selected_tool : int = 0

var _fade_in : float = 3;


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.use_accumulated_input = false
	ray = get_tree().get_first_node_in_group("raycast")
	inventory = get_tree().get_first_node_in_group("inventory")
	interact_label = get_tree().get_first_node_in_group("collect_rock_label")
	notification_node = get_tree().get_first_node_in_group("notification")
	for child in get_children():
		print(child)
		if(child.is_in_group("camera")):
			camera = child
			continue
	select_tool(0)

func select_tool(tool : int):
	print("select_tool(", tool, ")")
	if tool < 0 || tool >= $Camera3D/sway/tools.get_child_count():
		print("rejected")
		return
	
	for child in $Camera3D/sway/tools.get_children():
		child.visible = false
	
	_selected_tool = tool
	print("_selected_tool ", _selected_tool)
	$Camera3D/sway/tools.get_child(tool).visible = true

func _process(delta : float) -> void:
	if _fade_in > 0:
		$Control/blackening.color.a = _fade_in/3.0
		_fade_in -= min(delta, 0.02)
	
	camera_shake = move_toward(camera_shake, 0, delta)
	
	$Camera3D.v_offset = randf_range(-1,1) * pow(camera_shake, 0.5)*0.15
	$Camera3D.h_offset = randf_range(-1,1) * pow(camera_shake, 0.5)*0.15
	
	RenderingServer.global_shader_parameter_set("wave_time", Time.get_ticks_msec() / 1000.0)

func read_wave_image(v : Vector2i) -> float:
	v.x %= waves_heightmap.get_width()
	v.y %= waves_heightmap.get_height()
	
	if v.x < 0:
		v.x = waves_heightmap.get_width() - (-v.x) % waves_heightmap.get_width()
	
	if v.y < 0:
		v.y = waves_heightmap.get_height() - (-v.y) % waves_heightmap.get_height()
	
	return waves_heightmap.get_pixelv(v).r

func get_waves_height() -> float:
	var pos : Vector3 = global_position * 0.01
	var uv : Vector2i = Vector2(pos.x, pos.z) * Vector2(waves_heightmap.get_size())
	
	var time : float = Time.get_ticks_msec() / 1000.0
	var z : float = 1.0 - read_wave_image(uv*1.0 + Vector2(0, time*0.018));
	z *= 1.0 - read_wave_image(uv/1.3 + Vector2(time*0.01, 0));
	return (pow(z, 0.6)*0.15-0.05) * water_waves.scale.y * 103;

func die():
	if	(GameManager.world_state < GameManager.States.LIFTOFF):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://assets/nodes/death_menu.tscn");

var magma_geiser_spawn_timer = 1
var magma_geiser_spawn_time = 1

@export var magma_geiser : PackedScene

func _physics_process(delta: float) -> void:
	var wave_height = water_waves.global_position.y+get_waves_height();
	
	if GameManager.world_state < GameManager.States.LIFTOFF:
		planet_exploding_timer -= delta
		$Control/planet_text.text = "[font_size=20] Planet explodes in " + str(planet_exploding_timer).pad_decimals(0)
		
		
		if planet_exploding_timer < 0:
			$Control/planet_text.text = ""
			magma_geiser_spawn_timer -= delta
			if magma_geiser_spawn_timer < 0:
				magma_geiser_spawn_timer = magma_geiser_spawn_time
				magma_geiser_spawn_time *= 0.95
				
				camera_shake = 0.8
				
				var new_geiser = magma_geiser.instantiate()
				get_node("../water_for_waves").add_child(new_geiser)
				
				new_geiser.global_position.y = 100
				new_geiser.global_position.x = randf_range(-250, 250)
				new_geiser.global_position.z = randf_range(-250, 250)
				new_geiser.scale *= randf_range(0.8, 1.2)
			
	#print("wave height ", wave_height)
	#print("player height ", global_position.y)
	
	#pushback force
	if abs(global_position.x) > 200:
		if velocity.x < 0:
			velocity.x = lerpf(velocity.x, 10, delta*4)
		else:
			velocity.x = lerpf(velocity.x, -10, delta*4)
	
	if abs(global_position.z) > 200:
		if velocity.z < 0:
			velocity.z = lerpf(velocity.z, 10, delta*4)
		else:
			velocity.z = lerpf(velocity.z, -10, delta*4)
	
	
	if global_position.y > wave_height + camera.global_basis.z.dot(Vector3.UP):
		#above water
		print(camera.global_basis.z.dot(Vector3.UP))
		if (GameManager.world_state < GameManager.States.LIFTOFF):
			world_environment.set_env(1)
		
		_air_meter = move_toward(_air_meter, _air_reset, delta*14)
		if (GameManager.world_state != 6):
			if(global_position.y > wave_height+0.8):
				global_position.y = wave_height+0.8
		
		camera.attributes = camera_attributes[1];
	else:
		#under water
		if (GameManager.world_state < GameManager.States.LIFTOFF):
			world_environment.set_env(0)
		_air_meter -= delta
		camera.attributes = camera_attributes[1];
		
		if _air_meter < 0:
			die()
		
		
	$Control/blackening.color.a = clamp(1-_air_meter/10.0, 0, 1);
	$Control/Control/Air.text = "Air: " + str(_air_meter).pad_decimals(1)
	$Control/Control/TextureProgressBar.value = _air_meter/_air_reset * 100.0
	if(_air_meter > 10):
		$Control/Control/Air.text = "Air: " + str(_air_meter).pad_decimals(0)
	
	#make water follow player
	water_waves.global_position.x = global_position.x;
	water_waves.global_position.z = global_position.z;
	
	
	# Movement code
	var direction : Vector3 = Vector3(0,0,0)
	camera.rotation_degrees.z = 0

	var tilt : int = 0
	if (player_movement_enabled):
		if (Input.is_action_pressed("forward")):
			direction -= camera.global_transform.basis.z.normalized()
		if (Input.is_action_pressed("backwards")):
			direction += camera.global_transform.basis.z.normalized()
		if (Input.is_action_pressed("left")):
			# 1 is left, -1 is right
			tilt = 1
			direction -= camera.global_transform.basis.x.normalized()
		if (Input.is_action_pressed("right")):
			tilt = -1
			direction += camera.global_transform.basis.x.normalized()
		if(Input.is_action_pressed("up")):
			direction += Vector3.UP; #camera.global_transform.basis.y.normalized()
		if(Input.is_action_pressed("down")):
			direction -= Vector3.UP; #camera.global_transform.basis.y.normalized()
		
		velocity = velocity.lerp(direction.normalized() * speed, 0.05)
		
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

	# Check raycast collisions
	var collider : CollisionObject3D = ray.get_collider()
	if(collider != null):
		if (collider.is_in_group("rock")):
			if !collider.freeze:
				interact_label.text = "Collect rock " + collider.Ores.find_key(collider.oretype) + "\n [E]"
			else:
				interact_label.text = "Unmined rock " + collider.Ores.find_key(collider.oretype)
			
			interacting_with = "rock"
			current_rock = collider
			interact_label.visible = true
		if (collider.is_in_group("crusher")):
			interacting_with = "crusher"
			interact_label.text = "Crush ores in inventory\n [E]"
			interact_label.visible = true
			
			var found_ore = false
			for slot in range(0,inventory.inventory_slots.size()):
				match inventory.inventory_slots[slot].item:
					Ore.Ores.IRONIUM:
						found_ore = true
					Ore.Ores.QUARTZ:
						found_ore = true
					Ore.Ores.TARN:
						found_ore = true
					Ore.Ores.REDOGON:
						found_ore = true
			
			if !found_ore:
				interact_label.text = "No ores in inventory for crusher"
				
			
		if (collider.is_in_group("computer")):
			interacting_with = "computer"
			interact_label.text = "Submit resources\n [E]"
			interact_label.visible = true
		if (collider.is_in_group("rocket_door")):
			interacting_with = "rocket_door"
			if(GameManager.world_state == 5):
				interact_label.text = "Enter rocket\n [E]"
			else:
				interact_label.text = "Rocket not ready"
			interact_label.visible = true
	else:
		interacting_with = ""
		current_rock = null
		interact_label.visible = false
		
		

func give_air(air : float):
	_air_meter += air
	_air_meter = min(_air_meter, _air_reset)

func _input(event: InputEvent) -> void:
	# Rotate the camera view
	if(camera_movement_enabled):
		if (event is InputEventMouseMotion):
			if(Input.mouse_mode != 0):
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
			
			if _selected_tool != 0:
				$Camera3D/sway/tools.get_child(_selected_tool).do_action()
		
		if event.pressed && event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#select next tool
			var tool = _selected_tool + 1
			select_tool(tool)
			if _selected_tool != tool:
				select_tool(0)
		
		if event.pressed && event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#select next tool
			var tool = _selected_tool - 1
			select_tool(tool)
			if _selected_tool != tool:
				select_tool($Camera3D/sway/tools.get_child_count() - 1)
		return
	
	# Escape mouse capture
	if (event.is_action_pressed("escape")):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Run interact
	if(event.is_action_pressed("use")):
		if(interact_label.visible):
			if(current_rock != null) && !current_rock.freeze:
				var success : bool = false
				for slot in range(0,inventory.inventory_slots.size()):
					if(inventory.inventory_slots[slot].item == 0):
						inventory.inventory_slots[slot].item = current_rock.oretype
						success = true
						break
				if(success):
					current_rock.free()
			if	(interacting_with == "crusher"):
				# Go through all inventory slots and process them
				for slot in range(0,inventory.inventory_slots.size()):
					match inventory.inventory_slots[slot].item:
						Ore.Ores.IRONIUM:
							inventory.ironium_count += 1
						Ore.Ores.QUARTZ:
							inventory.quartz_count += 1
						Ore.Ores.TARN:
							inventory.tarn_count += 1
						Ore.Ores.REDOGON:
							inventory.redagon_count += 1
					# Set inventory to empty
					inventory.inventory_slots[slot].item = Ore.Ores.INVALID
					
			if (interacting_with == "computer"):
				var rocket : Rocket = get_tree().get_first_node_in_group("rocket")
				# build_array[0] is the Ore.Ores resource and build_array[1] is the total
				var build_array : Array = rocket.get_rocket_world_state_variable()
				if (build_array.size() == 0):
					notification_node.play_notification("Nothing to build\nRocket is finished")
					print("Nothing to build")
					return
				var success : Array[bool]
				for i in range(0,build_array[0].size()):
					print(inventory.get_resource_total(build_array[0][i]))
					if(build_array[1][i] <= inventory.get_resource_total(build_array[0][i])):
						success.append(true)
					else:
						success.append(false)
				var missing_items : String = ""
				var all_clear : bool = true
				for i in success.size():
					if (!success[i]):
						missing_items += Ore.Ores.keys()[build_array[0][i]] + " " + str(build_array[1][i]) + "\n"
						inventory.missing_item_label.text = "Missing resource:\n" + missing_items
						inventory.get_parent().visible = true
						inventory.missing_item_label.get_child(0).start()
						all_clear = false
						notification_node.play_notification("Not enough resources")
				if (all_clear):
					print("New gamestate")
					inventory.missing_item_label.text = ""
					GameManager.advanced_state()
					for i in success.size():
						inventory.set_new_resource_total(build_array[0][i], inventory.get_resource_total(build_array[0][i]) - build_array[1][i])
			
			if (interacting_with == "rocket_door"):
				if (GameManager.world_state == 5):
					GameManager.advanced_state()
					
	if(event.is_action_pressed("view_inventory")):
		inventory.get_parent().visible = true
	if(event.is_action_released("view_inventory")):
		inventory.get_parent().visible = false
