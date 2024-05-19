extends Node
@export var attack_range: Area2D
@export var sprite: AnimatedSprite2D
var atack_direction: Vector2
# execute the attack
func attack_action() -> void:
	var direction_to_player = (GameManager.player_position-get_parent().position).normalized()
	if direction_to_player.y > .75:
		sprite.set_animation("attack_down")
		atack_direction = Vector2.DOWN
	elif direction_to_player.y < -.75:
		sprite.set_animation("attack_up")
		atack_direction = Vector2.UP
	elif sprite.flip_h:
		sprite.set_animation("attack_side")
		atack_direction = Vector2.LEFT
	else:
		sprite.set_animation("attack_side")
		atack_direction = Vector2.RIGHT

	deal_damage()
	await get_tree().create_timer(0.6).timeout
	sprite.set_animation("idle")
	get_parent().attacking = false
	await get_tree().create_timer(0.6).timeout
	get_parent().can_attack = true

# decide when close enough and attack if can
func attack_decide(pos: Vector2, player_pos: Vector2, attacking: bool, can_attack: bool) -> String:
	if player_pos.distance_to(pos) < 60.0:
		if !attacking and can_attack:
			return "attack"
		else :
			return "wait"

	if attacking:
		return "wait"

	return ""


func deal_damage() -> void:
	while sprite.frame < 3:
		await Engine.get_main_loop().process_frame
		if sprite.frame >= 3:
			break
	var bodies = attack_range.get_overlapping_bodies()
	for body in bodies:
		if !is_instance_valid(body):
			return
		if body.is_in_group("player"):
			var enemy: Player = body
			var direction_to_enemy = (enemy.position-get_parent().position).normalized()
			var dot_product = direction_to_enemy.dot(atack_direction)
			if dot_product >= .35:
				body.take_damage(1)
