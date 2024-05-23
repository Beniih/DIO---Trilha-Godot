extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gold_pick: AudioStreamPlayer2D = $GoldPick
@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		area_2d.monitoring = false
		gold_pick.play(.4)
		body.gold_count += 1
		self.hide()
		await get_tree().create_timer(1.0).timeout
		self.queue_free()


func _on_timer_timeout() -> void:
	animation_player.play("timeout")
