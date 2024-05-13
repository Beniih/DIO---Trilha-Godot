extends CharacterBody2D

@export var speed : float = 200.0
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var knigh_blue: AnimatedSprite2D = $KnighBlue
var character_facing = "side"
var input_vector: Vector2 = Vector2(0.0,0.0)


func _process(delta: float) -> void:
	input_vector = Input.get_vector("move_l", "more_r", "move_u", "move_d")
	if abs(input_vector.x) < .2:
		input_vector.x = 0.0
	if abs(input_vector.y) < .2:
		input_vector.y = 0.0
	input_vector.normalized()


func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * speed

	if !animation_tree.active:
		return

	$AnimationTree["parameters/blend_position"] = input_vector

	velocity = lerp(velocity, target_velocity, .2)
	move_and_slide()
	GameManager.player_position = position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		animation_tree.active = false
		if input_vector.y > .75:
			character_facing = "down"
		elif input_vector.y < -.75:
			character_facing = "up"
		else:
			character_facing = "side"

		match character_facing:
			"up":
				knigh_blue.set_animation("attack_up_01")
			"down":
				knigh_blue.set_animation("attack_down_01")
			"side":
				knigh_blue.set_animation("attack_side_01")
		knigh_blue.play()
		deal_damage()

func _on_knigh_blue_animation_finished() -> void:
	knigh_blue.set_animation("idle")
	knigh_blue.play()
	animation_tree.active = true

func deal_damage() -> void:
	while $KnighBlue.frame < 3:
		await  get_tree().process_frame
	print("ATACKED!")
