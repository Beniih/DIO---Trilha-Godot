class_name Enemy
extends CharacterBody2D

@export var health: int = 10
var attacking: bool = false
var can_attack: bool = true
var player_position: Vector2 = Vector2(0.0,0.0)

func _physics_process(delta: float) -> void:
	player_position = GameManager.player_position
	#if player_position.distance_to(position) < 50.0 or attacking:
		#if !attacking:
			#attack()
		#return
	match $AttackNode.attack_decide(position, player_position, attacking, can_attack):
		"attack":
			attack()
			return
		"wait":
			return

	$FollowPlayer.follow_player(delta, player_position)

func attack() -> void:
	attacking = true
	can_attack = false
	if self.has_node("AttackNode"):
		$AttackNode.attack_action()
