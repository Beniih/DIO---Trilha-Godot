extends Node
@export var target_mark: Marker2D
@export var sprite: AnimatedSprite2D
var atack_direction: Vector2
const TNT = preload("res://elements/enemies/tnt.tscn")
# execute the attack
func attack_action() -> void:
	var direction_to_player = (GameManager.player_position-get_parent().position).normalized()
	sprite.set_animation("attack")
	await get_tree().create_timer(0.2).timeout
	deal_damage()
	await get_tree().create_timer(0.7).timeout
	sprite.set_animation("idle")
	sprite.play()
	get_parent().attacking = false
	await get_tree().create_timer(0.6).timeout
	get_parent().can_attack = true

# decide when close enough and attack if can
func attack_decide(pos: Vector2, player_pos: Vector2, attacking: bool, can_attack: bool) -> String:
	if player_pos.distance_to(pos) < 600.0:
		if !attacking and can_attack:
			return "attack"
		else :
			return "wait"

	if attacking:
		return "wait"

	return ""


func deal_damage() -> void:
	var ready_tnt = TNT.instantiate()
	ready_tnt.global_position = get_parent().global_position
	ready_tnt.target_pos = target_mark.position
	ready_tnt.explosion_pos = target_mark.global_position
	if get_node("/root/Main"):
		get_node("/root/Main").add_child(ready_tnt)
