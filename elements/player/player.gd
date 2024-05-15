class_name Player
extends CharacterBody2D
#---------------------status------------------------#
var nivel: int = 1
var xp: int = 0
var strenght: int = 1
var thougness: int = 1
var agility: int = 1
var max_stats: int = 10
#---------------------------------------------------#
@export var speed : float = 190.0
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var knigh_blue: AnimatedSprite2D = $KnighBlue
@onready var attack_colision: Area2D = $AttackColision
@export var health: int = 10
var max_health: int
var character_facing = "right"
var input_vector: Vector2 = Vector2(0.0,0.0)
var can_attack: bool = true


func _ready() -> void:
	max_health = (nivel * 5) + (thougness * 5)


func _process(delta: float) -> void:
	input_vector = Input.get_vector("move_l", "more_r", "move_u", "move_d")
	if abs(input_vector.x) < .2:
		input_vector.x = 0.0
	if abs(input_vector.y) < .2:
		input_vector.y = 0.0
	input_vector.normalized()


func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * (speed + (agility * 10))

	if !animation_tree.active:
		return

	$AnimationTree["parameters/blend_position"] = input_vector

	velocity = lerp(velocity, target_velocity, .1)
	move_and_slide()
	GameManager.player_position = position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack:
		animation_tree.active = false
		can_attack = false
		if input_vector.y > .75:
			character_facing = "down"
		elif input_vector.y < -.75:
			character_facing = "up"
		elif knigh_blue.flip_h:
			character_facing = "left"
		else:
			character_facing = "right"

		match character_facing:
			"up":
				knigh_blue.set_animation("attack_up_01")
			"down":
				knigh_blue.set_animation("attack_down_01")
			"left":
				knigh_blue.set_animation("attack_side_01")
			"right":
				knigh_blue.set_animation("attack_side_01")
		knigh_blue.play()
		deal_damage()


func _on_knigh_blue_animation_finished() -> void:
	knigh_blue.set_animation("idle")
	knigh_blue.play()
	animation_tree.active = true
	can_attack = true


func deal_damage() -> void:
# wait valid attack frame from animation
	while $KnighBlue.frame < 3:
		await  get_tree().process_frame
# get the enemy near
	var bodies = attack_colision.get_overlapping_bodies()
	for body in bodies:
		if !is_instance_valid(body):
			return
		if body.is_in_group("enemy"):
			var enemy: Enemy = body
# calculate directions
			var direction_to_enemy = (enemy.position-position).normalized()
			var atack_direction: Vector2
			if character_facing == "up":
				atack_direction = Vector2.UP
			elif character_facing == "down":
				atack_direction = Vector2.DOWN
			elif character_facing == "left":
				atack_direction = Vector2.LEFT
			else:
				atack_direction = Vector2.RIGHT
# calculate if enemy get hited and hit
			var dot_product = direction_to_enemy.dot(atack_direction)
			if dot_product >= .35:
				body.take_damage(strenght)


func take_damage(amount):
	var tween = create_tween()
	if health <= 0:
		get_tree().call_deferred("reload_current_scene")
		return
	tween.set_trans(Tween.TRANS_BOUNCE)
	health -= amount
	#tween.tween_property($Sprite, "skew",.6,.1)
	modulate = Color.RED
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func get_xp(amount):
	var to_next_level: int = 75 + ((nivel - 1) * 5) + (nivel * nivel * 25)
	xp += amount
	if xp >= to_next_level:
		nivel += 1
