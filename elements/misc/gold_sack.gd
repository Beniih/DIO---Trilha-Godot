extends AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.gold_count += 1
		self.queue_free()


func _on_timer_timeout() -> void:
	self.queue_free()
