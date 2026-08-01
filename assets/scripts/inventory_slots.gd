class_name inventory_slot
extends Control

var item : Ore.Ores :
	set(value):
		item = value
		set_item(value)
		
func set_item(value : Ore.Ores):
	if(value == 0):
		get_node("Label").text = ""
		get_node("TextureRect").texture = null
	else:
		get_node("Label").text = Ore.Ores.keys()[value]
		get_node("TextureRect").texture = get_parent().get_parent().get_ore_icon(value - 1)
