extends Node

@export var death_prefab: PackedScene

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = get_parent().position
		get_parent().add_child(death_object)
	queue_free()
