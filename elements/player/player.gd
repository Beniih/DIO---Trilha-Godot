class_name Player
extends CharacterBody2D
#---------------------status------------------------#
var nivel: int = 1
var xp: int = 0
var to_next_level: int = 60
var strenght: int = 1
var thougness: int = 1
var agility: int = 1
#---------------------------------------------------#
@export var speed : float = 190.0
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var knigh_blue: AnimatedSprite2D = $KnighBlue
@onready var attack_colision: Area2D = $AttackColision
@export var health: int = 10
@onready var hp_bar: ProgressBar = $hp_bar_anchor/hp_bar
var gold_count: int = 0
const AURA = preload("res://elements/misc/aura.tscn")
var max_health: int
var character_facing = "right"
var input_vector: Vector2 = Vector2(0.0,0.0)
var can_attack: bool = true


func _ready() -> void:
	max_health = (nivel * 5) + (thougness * 5)
	GameManager.xp_received.connect(get_xp, 1)


func _process(delta: float) -> void:
	input_vector = Input.get_vector("move_l", "more_r", "move_u", "move_d")
	if abs(input_vector.x) < .2:
		input_vector.x = 0.0
	if abs(input_vector.y) < .2:
		input_vector.y = 0.0
	input_vector.normalized()
	hp_bar.max_value = max_health
	hp_bar.value = health
	GameManager.player_position = position
	GameManager.gold_count = gold_count
	GameManager.total_xp = xp


func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * (speed + (agility * 10))
# avoid move while attacking
	if !animation_tree.active:
		return

	$AnimationTree["parameters/blend_position"] = input_vector

	velocity = lerp(velocity, target_velocity, .1)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack:
		animation_tree.active = false
		can_attack = false
		if input_vector.y > .75:
			character_facing = "down"
			knigh_blue.set_animation("attack_down_01")
		elif input_vector.y < -.75:
			character_facing = "up"
			knigh_blue.set_animation("attack_up_01")
		elif knigh_blue.flip_h:
			character_facing = "left"
			knigh_blue.set_animation("attack_side_01")
		else:
			character_facing = "right"
			knigh_blue.set_animation("attack_side_01")

		knigh_blue.play() # avoid behavior where animation stops
		deal_damage()


func _on_knigh_blue_animation_finished() -> void:
	knigh_blue.set_animation("idle")
	knigh_blue.play()
	animation_tree.active = true
	can_attack = true


func deal_damage() -> void:
# wait valid attack frame from animation
	while $KnighBlue.frame < 3:
		if $KnighBlue.frame >= 3:
			break
		await Engine.get_main_loop().process_frame
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
				var dmg: int = strenght + int(nivel / 2)
				body.take_damage(dmg, true)


func take_damage(amount):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	health -= amount
	if health <= 0:
		GameManager.call_game_over()
		self.queue_free()
	modulate = Color.RED
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func get_xp(amount):
	xp += amount
	if xp >= to_next_level:
		nivel += 1
		to_next_level = 75 + ((nivel - 1) * 35) + (nivel * nivel * 25)
		GameManager.nivel = nivel
		GameManager.level_up.emit()


func regen_health(amout):
	health += amout
	health = clamp(health,0,max_health)


func _on_aura_timer_timeout() -> void:
	if AURA:
		var magic_aura = AURA.instantiate()
		add_child(magic_aura)


func update_health():
	max_health = (nivel * 5) + (thougness * 5)
	health = max_health
