extends Node

@export var speed: float = 1.0
var attacking: bool = false
@onready var enemy: Enemy = get_parent()
@onready var sprite: AnimatedSprite2D = enemy.get_node("Sprite")

# get direction and make the movement
func follow_player(delta: float, player_position: Vector2) -> void:
	var direction = player_position - enemy.position

	if enemy.has_node("Sprite"):
		sprite.set_animation("run")
		if direction.x > 0.0:
			sprite.flip_h = false
		elif direction.x < 0.0:
			sprite.flip_h = true

	var input_vector = direction.normalized()
	enemy.velocity = input_vector * speed * 100.0

	enemy.move_and_slide()
