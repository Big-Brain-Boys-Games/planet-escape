class_name Rocket
extends Node3D

var body_parts : Array[Ore.Ores] = [Ore.Ores.IRONIUM, Ore.Ores.TARN]
var body_count : Array[int] = [5,4]

var engine_parts : Array[Ore.Ores] = [Ore.Ores.IRONIUM, Ore.Ores.REDOGON]
var engine_count : Array[int] = [5,2]

var cockpit_parts : Array[Ore.Ores] = [Ore.Ores.QUARTZ, Ore.Ores.TARN]
var cockpit_count : Array[int] = [8,5]

var booster_parts : Array[Ore.Ores] = [Ore.Ores.IRONIUM, Ore.Ores.TARN, Ore.Ores.REDOGON]
var booster_count : Array[int] = [5,4,2]

func get_rocket_world_state_variable() -> Array:
	match GameManager.world_state:
		1:
			return [body_parts, body_count]
		2:
			return [engine_parts, engine_count]
		3:
			return [cockpit_parts, cockpit_count]
		4:
			return [booster_parts,booster_count]
		_:
			return []
