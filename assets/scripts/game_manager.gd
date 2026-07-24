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

var world_state : int = 1

func advanced_state() -> void:
	world_state += 1
