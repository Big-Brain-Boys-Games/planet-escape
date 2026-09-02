class_name EnvironmentManager
extends WorldEnvironment

@export var environments : Array[Environment];

var current_environment = -1;

var player;

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func set_env(num : int):
	if num == current_environment:
		return
	#print("setting environment to ", environments[num].to_string(), " from ", environments[current_environment].to_string())
	environment = environments[num];
	current_environment = num

func _physics_process(delta: float) -> void:
	if player.planet_exploding_timer < 0 && current_environment == 0:
		environment.volumetric_fog_albedo = environment.volumetric_fog_albedo.lerp(Color(0.971, 0.641, 0.817), delta*0.15)
