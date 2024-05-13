class_name Enemy
extends CharacterBody2D

@export var health: int = 10
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
