extends Node
@export var attack_range: Area2D
@export var sprite: AnimatedSprite2D
var atack_direction: Vector2
# execute the attack
func attack_action() -> void:
	var direction_to_player = (GameManager.player_position-get_parent().position).normalized()

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
	pass
