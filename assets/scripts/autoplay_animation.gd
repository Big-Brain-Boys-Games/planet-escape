extends Node3D

@export var animationPlayer_path : String
@export var animation : String

func _ready():
	get_node(animationPlayer_path).current_animation = animation
