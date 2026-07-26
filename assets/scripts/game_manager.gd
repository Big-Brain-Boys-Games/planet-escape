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
var world_environment : EnvironmentManager
var objective_text : RichTextLabel
var music_player : MusicManager

# ALL VARIABLES FOR STAGE 1
var music1 : AudioStreamOggVorbis = preload("res://assets/audio/music/ambient2(Nautilus).ogg")

# ALL VARIABLES FOR STAGE 2
var rocket_body : MeshInstance3D

# ALL VARIABLES FOR STAGE 3
var rocket_engine : MeshInstance3D
var music2 : AudioStreamOggVorbis = preload("res://assets/audio/music/Exploration Theme.ogg")

# ALL VARIABLES FOR STAGE 4
var rocket_cockpit : MeshInstance3D

# ALL VARIABLES FOR STAGE 5
var rocket_boosters : Node3D
var music3 : AudioStreamOggVorbis = preload("res://assets/audio/music/Beyond_the_Stars_Ambient_.ogg")

# ALL VARIABLES FOR STAGE 6
var seat_location : Node3D
var planet_environment : Node3D
var liftoff_animation : AnimationPlayer
var transition_environment : Environment = preload("res://assets/worldEnvironments/abovewater_environment.tres") as Environment
var space_sky : Sky = preload("res://assets/worldEnvironments/Skies/space_sky.tres") as Sky

# ALL VARIABLES FOR STAGE 7
var space_environment : Environment = preload("res://assets/worldEnvironments/space.tres") as Environment
var music7 : AudioStreamOggVorbis = preload("res://assets/audio/music/Synth - Chopin - Fantaisie-impromptu - 120BPM.ogg")

func _ready() -> void:
	get_tree().scene_changed.connect(_setup_world)
	
func _setup_world() -> void:
	if (get_tree().get_first_node_in_group("player")):
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
		objective_text = get_tree().get_first_node_in_group("objective")
		music_player = get_tree().get_first_node_in_group("music_manager")
		advanced_state()
		
var world_state : States = 0
enum States {WAKEUP,OCEAN,ROCKET_BODY,ROCKET_ENGINE,ROCKET_COCKPIT,ROCKET_BOOSTERS,LIFTOFF,SPACE,GOING,TRAVEL,END}

func advanced_state() -> void:
	world_state += 1
	
	match world_state:
		States.WAKEUP:
			pass
		States.OCEAN:
			music_player.change_music(music1,5,5)
			objective_text.text = "[font_size=23]Current objective[/font_size]\nBuild the rocket using the computer"
			pass
		States.ROCKET_BODY:
			objective_text.text = "[font_size=23]Current objective[/font_size]\nBuild the rocket engine"
			notification_node.play_notification("First stage build, commence second stage.")
			rocket_body.visible = true
		States.ROCKET_ENGINE:
			music_player.change_music(music2,5,5)
			objective_text.text = "[font_size=23]Current objective[/font_size]\nBuild the rocket cockpit"
			notification_node.play_notification("Second stage build, commence third stage")
			rocket_engine.visible = true
		States.ROCKET_COCKPIT:
			objective_text.text = "[font_size=23]Current objective[/font_size]\nBuild the rocket boosters"
			notification_node.play_notification("Third stage build, commence fourth stage")
			rocket_cockpit.visible = true
		States.ROCKET_BOOSTERS:
			music_player.change_music(music3,5,5)
			objective_text.text = "[font_size=23]Current objective[/font_size]\n Enter the rocket and escape the planet"
			notification_node.play_notification("fourth stage build, rocket ready for lift-off")
			rocket_boosters.visible = true
		States.LIFTOFF:
			objective_text.text = "[font_size=23]Current objective[/font_size]\n Enjoy the view"
			notification_node.play_notification("Lift off!")
			player._fade_in = 3
			player.player_movement_enabled = false
			player.global_position = seat_location.global_position
			planet_environment.visible = false
			world_environment.set_env(1)
			liftoff_animation.play("leaving_planet")
		States.SPACE:
			music_player.change_music(music7,1,1)
			objective_text.text = "[font_size=23]Current objective[/font_size]\n You Win!"
			notification_node.play_notification("The game has been won. Congratulations!")
			world_environment.environment = space_environment
		States.GOING:
			pass
		States.TRAVEL:
			pass
		States.END:
			pass
