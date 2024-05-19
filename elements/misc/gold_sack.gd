extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.gold_count += 1
		self.queue_free()


func _on_timer_timeout() -> void:
	animation_player.play("timeout")
