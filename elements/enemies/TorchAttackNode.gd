extends Node

func attack_action() -> void:
	if get_parent().has_node("Sprite"):
		$"../Sprite".set_animation("attack_side")
		await get_tree().create_timer(0.6).timeout
		$"../Sprite".set_animation("idle")
		get_parent().attacking = false
		await get_tree().create_timer(0.6).timeout
		get_parent().can_attack = true

func attack_decide(pos, player_pos, attacking, can_attack):
	if player_pos.distance_to(pos) < 50.0:
		if !attacking and can_attack:
			return "attack"
		else :
			return "wait"

	if attacking:
		return "wait"
