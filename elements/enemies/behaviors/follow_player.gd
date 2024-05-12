extends CharacterBody2D

@export var speed: float = 1.0
var player_position: Vector2 = Vector2(0.0,0.0)
var attacking: bool = false

func _physics_process(delta: float) -> void:
	player_position = GameManager.player_position
	var direction = player_position - position

	if player_position.distance_to(position) < 50.0:
		if !attacking:
			attack()
		return

	if self.has_node("Sprite"):
		if direction.x > 0.0:
			$"Sprite".flip_h = false
		elif direction.x < 0.0:
			$"Sprite".flip_h = true

	var input_vector = direction.normalized()
	velocity = input_vector * speed * 100.0

	move_and_slide()

func attack() -> void:
	attacking = true
	print("Attack")
	await get_tree().create_timer(1).timeout
	attacking = false
	pass
