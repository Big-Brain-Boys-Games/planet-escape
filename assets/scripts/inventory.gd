class_name Inventory
extends Control

@export var inventory_slots : Array[Node] = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
@export var total_text : RichTextLabel

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

func _ready() -> void:
	var current_item : int = 0
	for child in get_child(1).get_children():
		if (is_instance_of(child,ColorRect)):
			inventory_slots[current_item] = child
			current_item += 1

func update_text() -> void:
	total_text.text = "
	Resources:
		
	Ironium: " + str(ironium_count) + "
	Quartz: " + str(quartz_count) + "
	Tarn: " + str(tarn_count) + "
	Redagon " + str(redagon_count)
