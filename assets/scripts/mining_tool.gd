extends Node3D

var attack : float = 0
var attack_length : float = 1
var starting_position : Vector3 = position

@export var ore_icons : Array[Texture2D]
@onready var drill_sound : AudioStreamPlayer = $AudioStreamPlayer
var cylinder : Node3D

func _ready():
	cylinder = get_node("Cylinder")

func do_action():
	if attack > 0:
		return
	#print("do mining attack")
	drill_sound.play()
	attack = attack_length

func _process(delta: float) -> void:
	var time : float = sin((1-attack/attack_length) * PI)
	
	time = pow(time, 0.5)
	
	if attack > 0:
		
		var over_half = (attack/attack_length) > 0.7
		attack -= delta
		if over_half and (attack/attack_length) < 0.7:
			#do actual mining
			if($"../../../..".interact_label.visible && $"../../../..".current_rock != null):
				$"../../../..".current_rock.get_node("rock1").visible = false
				$"../../../..".current_rock.freeze = false
			
	else:
		time = 0
	
	cylinder.rotate_x(delta * time * 7)
		
	rotation_degrees.y = 100 + time * 20
	
	position = starting_position.lerp(Vector3(starting_position.x - 0.27, starting_position.y - 0.129, starting_position.z - 0.663), time)
	#position = Vector3(0.699, 0.09, -0.987).lerp(Vector3(0.429, -0.039, -1.65), time)

func change_icon_display(ore : Ore.Ores) -> void:
	$SubViewport/Control/TextureRect.texture = ore_icons[ore]
