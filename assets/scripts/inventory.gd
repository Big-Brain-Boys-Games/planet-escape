class_name Inventory
extends Control

@export var inventory_slots : Array[Node] = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]

func _ready() -> void:
	var current_item : int = 0
	for child in get_child(0).get_children():
		print(child)
		if (is_instance_of(child,ColorRect)):
			inventory_slots[current_item] = child
			current_item += 1
	print(inventory_slots)
