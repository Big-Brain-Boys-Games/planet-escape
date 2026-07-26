extends Node3D

var rand_time = 3

func _ready():
	for child in $planet_exploding.get_children():
		child.scale *= 0.4
		child.position *= 1.2


var magma_timer :float = 0
var chunk = null
func _physics_process(delta: float) -> void:
	if GameManager.world_state < GameManager.States.SPACE:
		return
	
	magma_timer += delta * 0.1
	$planet_magma.rotate_x(delta)
	$planet_magma.rotate_z(-delta * 0.6)
	
	var magma_scale = 0.3 * (min(magma_timer*0.6, 1.45) + sin(magma_timer*6.5)*0.3)
	$planet_magma.scale = Vector3.ONE * min(magma_scale, 0.55)
	
	
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
