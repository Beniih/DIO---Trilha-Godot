extends Node
@export var attack_range: Area2D
@export var sprite: AnimatedSprite2D
# execute the attack
func attack_action() -> void:
	if get_parent().has_node("Sprite"):
		sprite.set_animation("redy_explosion")
		await get_tree().create_timer(0.4).timeout
		sprite.set_animation("explosion")
		deal_damage()

# decide when close enough and attack if can
func attack_decide(pos: Vector2, player_pos: Vector2, attacking: bool, can_attack: bool) -> String:
	if player_pos.distance_to(pos) < 50.0 or attacking:
		if !attacking and can_attack:
			return "attack"
		return "wait"
	return ""


func deal_damage() -> void:
	while sprite.frame < 1:
		await  get_tree().process_frame
	var bodies = attack_range.get_overlapping_bodies()
	for body in bodies:
		if is_instance_valid(body) and body != get_parent():
			body.take_damage(3)
	await sprite.animation_finished
	get_parent().queue_free()
