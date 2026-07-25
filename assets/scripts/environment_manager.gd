class_name EnvironmentManager
extends WorldEnvironment

@export var environments : Array[Environment];

var current_environment = -1;

func set_env(num : int):
	if num == current_environment:
		return
	print("setting environment to ", environments[num].to_string(), " from ", environments[current_environment].to_string())
	environment = environments[num];
	current_environment = num
