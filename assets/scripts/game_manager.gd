extends Node
## The game manager
##
## state 0: wakeup
## state 1: ocean gameplay
## state 2: build rocket body
## state 3: build rocket engine
## state 4: build rocket cockpit
## state 5: build rocket boosters
## state 6: going to space
## state 7: space gameplay
## state 8: going to travel
## state 9: travel gameplay
## state 10: the end

var notification_node : notification

# ALL VARIABLES FOR STAGE 1

# ALL VARIABLES FOR STAGE 2
var rocket_body : MeshInstance3D

# ALL VARIABLES FOR STAGE 3
var rocket_engine : MeshInstance3D

# ALL VARIABLES FOR STAGE 4
var rocket_cockpit : MeshInstance3D

# ALL VARIABLES FOR STAGE 5
var rocket_boosters : Node3D

func _ready() -> void:
	notification_node = get_tree().get_first_node_in_group("notification")
	rocket_body = get_tree().get_first_node_in_group("rocket_body")
	rocket_engine = get_tree().get_first_node_in_group("rocket_engine")
	rocket_cockpit = get_tree().get_first_node_in_group("rocket_cockpit")
	rocket_boosters = get_tree().get_first_node_in_group("rocket_boosters")

var world_state : int = 1

func advanced_state() -> void:
	world_state += 1
	
	match world_state:
		0:
			pass
		1:
			pass
		2:
			notification_node.play_notification("First stage build, commence second stage.")
			rocket_body.visible = true
		3:
			notification_node.play_notification("Second stage build, commence third stage")
			rocket_engine.visible = true
		4:
			notification_node.play_notification("Third stage build, commence fourth stage")
			rocket_cockpit.visible = true
		5:
			notification_node.play_notification("fourth stage build, rocket ready for lift-off")
			rocket_boosters.visible = true
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass
