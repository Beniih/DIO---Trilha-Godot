class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var death_prefab: PackedScene
var attacking: bool = false
var can_attack: bool = true
var player_position: Vector2 = Vector2(0.0,0.0)


func _physics_process(delta: float) -> void:
	player_position = GameManager.player_position # get player position from singleton
# decide when close enough and attack if can
	match $AttackNode.attack_decide(position, player_position, attacking, can_attack):
		"attack":
			attack()
			return
		"wait":
			return
# calls the movement function
	$FollowPlayer.follow_player(delta, player_position)


func attack() -> void: # call attack
	attacking = true
	can_attack = false
	if self.has_node("AttackNode"):
		$AttackNode.attack_action()


func take_damage(amount):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	health -= amount
	if health <= 0:
		call_deferred("die")
	modulate = Color.RED
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
