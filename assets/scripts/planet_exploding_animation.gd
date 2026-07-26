extends Node3D

var rand_time = 3

@export var magma_material : Material
@export var anime_explosion_effect : PackedScene
@export var meteor : PackedScene

func _ready():
	for child in $planet_exploding.get_children():
		child.scale *= 0.4
		child.position *= 1.2
		child.set_surface_override_material(0, magma_material)


var magma_timer :float = 0
var explosion_effect_spawner : float = 1
var chunk = null
func _physics_process(delta: float) -> void:
	if GameManager.world_state < GameManager.States.SPACE:
		return
	
	if magma_timer > 2.3:
		for child in get_children():
			var pos = child.global_position
			child.global_position += child.global_position.direction_to(global_position) * -50 * delta
			child.rotate_x(delta*4)
	
	else:
		magma_timer += delta * 0.1
		print("magma_timer ", magma_timer)
		if magma_timer > 2.3:
			for child in get_children():
				child.queue_free()
			
			#spawn meteors
			for i in range(50):
				var effect = meteor.instantiate()
				add_child(effect)
				effect.position = Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI)) * 0.2
				effect.scale = Vector3.ONE * randf_range(0.7, 1) * 0.03
				effect.quaternion = Quaternion.from_euler(Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI))).normalized()
			return
		
		$planet_magma.rotate_x(delta)
		$planet_magma.rotate_z(-delta * 0.6)
		
		var magma_scale = 0.3 * (min(magma_timer*0.6, 1.45) + sin(magma_timer*6.5)*0.3)
		$planet_magma.scale = Vector3.ONE * min(magma_scale, 0.55)

		if magma_timer > 1:
			#do explosion
			explosion_effect_spawner -= delta
			
			for effect : Node3D in $effect.get_children():
				effect.rotate_x(delta*0.02)
			
			if explosion_effect_spawner < 0:
				explosion_effect_spawner = randf_range(0, 0.3)
				#spawn
				var effect = anime_explosion_effect.instantiate()
				$effect.add_child(effect)
				effect.position = Vector3.ZERO
				effect.scale = Vector3.ONE * randf_range(0.7, 1)
				effect.quaternion = Quaternion.from_euler(Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI))).normalized()
		
		
		if magma_timer > 0.3:
			$planet.get_surface_override_material(0).albedo_color = $planet.get_surface_override_material(0).albedo_color.lerp(Color(0.422, 0.255, 0.438), delta * 0.1)
		
		if chunk:
			chunk.position *= 1 + delta*0.1
		
		rand_time -= delta
		if rand_time < 0:
			rand_time = randf_range(0, 0.6)
			
			var idx = randi_range(0, $planet_exploding.get_child_count()-2)
			
			chunk = $planet_exploding.get_child(idx)
			
			
			get_tree().get_first_node_in_group("player").camera_shake = 0.2
