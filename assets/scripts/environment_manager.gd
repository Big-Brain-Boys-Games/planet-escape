extends WorldEnvironment

@export var environments : Array[Environment];

func set_env(num : int):
	environment = environments[num];
