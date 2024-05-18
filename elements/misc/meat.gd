extends Node2D

@export var health_regeneration: int = 10



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.regen_health(health_regeneration)
		self.queue_free()
