class_name Inventory
extends Control

@export var inventory_slots : Array[Node] = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
@export var total_text : RichTextLabel
@export var missing_item_label : RichTextLabel

var ironium_count : int :
	set(value):
		ironium_count = value
		update_text()
var quartz_count : int :
	set(value):
		quartz_count = value
		update_text()
var tarn_count : int :
	set(value):
		tarn_count = value
		update_text()
var redagon_count : int :
	set(value):
		redagon_count = value
		update_text()

func get_resource_total (ore : Ore.Ores) -> int:
	match ore:
		1:
			return ironium_count
		2:
			return quartz_count
		3:
			return tarn_count
		4:
			return redagon_count
	return 0

func set_new_resource_total (ore : Ore.Ores, value : int) -> void:
	match ore:
		1:
			ironium_count = value
		2:
			quartz_count = value
		3:
			tarn_count = value
		4:
			redagon_count = value
	
func _ready() -> void:
	var current_item : int = 0
	for child in get_child(1).get_children():
		if (is_instance_of(child,ColorRect)):
			inventory_slots[current_item] = child
			current_item += 1

func update_text() -> void:
	total_text.text = "Resources:
		
	Ironium: " + str(ironium_count) + "
	Quartz: " + str(quartz_count) + "
	Tarn: " + str(tarn_count) + "
	Redagon " + str(redagon_count)

func _missing_item_text_timeout() -> void:
	get_parent().visible = false
