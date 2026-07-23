class_name inventory_slot
extends Control

var item : Ore.Ores :
	set(value):
		item = value
		set_item(value)
		
func set_item(value : Ore.Ores):
	get_child(0).text = Ore.Ores.keys()[value]
