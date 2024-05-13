extends Node
# execute the attack
func attack_action() -> void:
	if get_parent().has_node("Sprite"):
		$"../Sprite".set_animation("attack_side")
		deal_damage()
		await get_tree().create_timer(0.6).timeout
		$"../Sprite".set_animation("idle")
		get_parent().attacking = false
		await get_tree().create_timer(0.6).timeout
		get_parent().can_attack = true
# decide when close enough and attack if can
func attack_decide(pos: Vector2, player_pos: Vector2, attacking: bool, can_attack: bool) -> String:
	if player_pos.distance_to(pos) < 50.0:
		if !attacking and can_attack:
			return "attack"
		else :
			return "wait"

	if attacking:
		return "wait"

	return ""

func deal_damage() -> void:
	while $"../Sprite".frame < 3:
		await  get_tree().process_frame
	print("ATACKED!")
