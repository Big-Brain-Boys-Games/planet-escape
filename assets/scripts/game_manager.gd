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
var player : Player
var world_environment : WorldEnvironment

# ALL VARIABLES FOR STAGE 1

# ALL VARIABLES FOR STAGE 2
var rocket_body : MeshInstance3D

# ALL VARIABLES FOR STAGE 3
var rocket_engine : MeshInstance3D

# ALL VARIABLES FOR STAGE 4
var rocket_cockpit : MeshInstance3D

# ALL VARIABLES FOR STAGE 5
var rocket_boosters : Node3D

# ALL VARIABLES FOR STAGE 6
var seat_location : Node3D
var planet_environment : Node3D
var liftoff_animation : AnimationPlayer
var transition_environment : Environment = preload("res://assets/worldEnvironments/transition_to_space.tres") as Environment
var space_sky : Sky = preload("res://assets/worldEnvironments/Skies/space_sky.tres") as Sky

# ALL VARIABLES FOR STAGE 7
var space_environment : Environment = preload("res://assets/worldEnvironments/space.tres") as Environment
func _ready() -> void:
	notification_node = get_tree().get_first_node_in_group("notification")
	rocket_body = get_tree().get_first_node_in_group("rocket_body")
	rocket_engine = get_tree().get_first_node_in_group("rocket_engine")
	rocket_cockpit = get_tree().get_first_node_in_group("rocket_cockpit")
	rocket_boosters = get_tree().get_first_node_in_group("rocket_boosters")
	player = get_tree().get_first_node_in_group("player")
	seat_location = get_tree().get_first_node_in_group("seat_location")
	planet_environment = get_tree().get_first_node_in_group("planet_environment")
	liftoff_animation = get_tree().get_first_node_in_group("liftoff_animation")
	world_environment = get_tree().get_first_node_in_group("world_environment")
	

var world_state : States = 1
enum States {WAKEUP,OCEAN,ROCKET_BODY,ROCKET_ENGINE,ROCKET_COCKPIT,ROCKET_BOOSTERS,LIFTOFF,SPACE,GOING,TRAVEL,END}

func advanced_state() -> void:
	world_state += 1
	
	match world_state:
		States.WAKEUP:
			pass
		States.OCEAN:
			pass
		States.ROCKET_BODY:
			notification_node.play_notification("First stage build, commence second stage.")
			rocket_body.visible = true
		States.ROCKET_ENGINE:
			notification_node.play_notification("Second stage build, commence third stage")
			rocket_engine.visible = true
		States.ROCKET_COCKPIT:
			notification_node.play_notification("Third stage build, commence fourth stage")
			rocket_cockpit.visible = true
		States.ROCKET_BOOSTERS:
			notification_node.play_notification("fourth stage build, rocket ready for lift-off")
			rocket_boosters.visible = true
		States.LIFTOFF:
			notification_node.play_notification("Lift off!")
			player.player_movement_enabled = false
			player.global_position = seat_location.global_position
			planet_environment.visible = false
			world_environment.environment = transition_environment
			liftoff_animation.play("leaving_planet")
		States.SPACE:
			world_environment.environment = space_environment
		States.GOING:
			pass
		States.TRAVEL:
			pass
		States.END:
			pass
