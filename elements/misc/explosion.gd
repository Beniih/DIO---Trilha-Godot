extends Node2D

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	await get_tree().create_timer(.1).timeout
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if !is_instance_valid(body):
			return
		var damage: int = 1 + floori(body.health * .1)
		body.take_damage(damage)

func _on_animated_sprite_2d_4_animation_finished() -> void:
	self.queue_free()
