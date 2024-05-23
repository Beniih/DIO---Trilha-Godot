extends Node2D

@export var health_regeneration: int = 10
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var heal_fx: AudioStreamPlayer2D = $healFX
@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		area_2d.monitoring = false
		heal_fx.play(0.0)
		body.regen_health(health_regeneration)
		self.hide()
		await get_tree().create_timer(1.1).timeout
		self.queue_free()


func _on_timer_timeout() -> void:
	animation_player.play("timeout")
