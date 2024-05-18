class_name Enemy
extends CharacterBody2D

@export var health: int = 10
@export var death_prefab: PackedScene
@export var itens: Array[PackedScene]
@onready var damage_digit_anchor: Marker2D = $DamageDigitAnchor
const DAMAGE_DIGIT: PackedScene = preload("res://elements/misc/damage_digit.tscn")
var attacking: bool = false
var can_attack: bool = true
var player_position: Vector2 = Vector2(0.0,0.0)
var xp_amout: int = 0

func _ready() -> void:
	xp_amout = health

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


func take_damage(amount, player: bool = false):
	var damage_digit = DAMAGE_DIGIT.instantiate()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	health -= amount
	# spawn damage digit
	damage_digit.value = amount
	damage_digit.global_position = damage_digit_anchor.global_position
	get_parent().add_child(damage_digit)
	# check if it's alive
	if health <= 0:
		call_deferred("die", player)
	modulate = Color.RED
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func die(player: bool = false):
	var drop = randf()
	if player:
		GameManager.xp_received.emit(xp_amout)
	if itens and drop <= .2:
		var item = itens.pick_random().instantiate()
		item.global_position = global_position
		get_parent().add_child(item)
	elif death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
