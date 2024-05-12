extends Node

#const EXPLOSION = preload("res://elements/effects/explosion.tscn")

func attack_action() -> void:
	if get_parent().has_node("Sprite"):
		$"../Sprite".set_animation("redy_explosion")
		await get_tree().create_timer(0.4).timeout
		$"../Sprite".set_animation("explosion")
		#var explode = EXPLOSION.instantiate()
		#explode.position = get_parent().position
		#add_child(explode)
		await get_tree().create_timer(0.5).timeout
		get_parent().queue_free()

func attack_decide(pos, player_pos, attacking, can_attack):
	if player_pos.distance_to(pos) < 50.0 or attacking:
		if !attacking and can_attack:
			return "attack"
		return "wait"
