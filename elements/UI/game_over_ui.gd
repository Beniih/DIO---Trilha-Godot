extends CanvasLayer

@onready var score_points = GameManager.score
@onready var score_info: Label = $Panel/CenterContainer/GridContainer/ScoreInfo
@onready var ranking_info: Label = $Panel/CenterContainer/GridContainer/RankingInfo
@onready var pointer: TextureRect = $Pointer
var select_1: Vector2 = Vector2(174.0,212.0)
var select_2: Vector2 = Vector2(174.0,330.0)
var selected = 1
var enable_menu = false

func _ready() -> void:
	var rank = hero_level_calc(score_points)
	var score_msg = "Sua pontuação total foi " + str(score_points) + "!"
	var rank_msg = "Seu ranking de heóri é " + rank + "!"
	score_info.text = score_msg
	ranking_info.text = rank_msg

func _process(delta: float) -> void:
	if !enable_menu: return

	if selected == 1:
		pointer.position = select_1
	elif selected == 2:
		pointer.position = select_2

	if Input.is_action_just_pressed("attack"):
		if selected == 1:
			GameManager.reset()
			get_tree().reload_current_scene()
		elif selected == 2:
			get_tree().quit()

	if Input.is_action_just_pressed("move_u") or Input.is_action_just_pressed("move_d"):
		print(selected)
		if selected == 1:
			selected = 2
		elif selected == 2:
			selected = 1


func hero_level_calc(score_points) -> String:
	var hero_level = ""
	
	if score_points <= 500:
		hero_level = "Ferro"
	elif score_points <= 1000:
		hero_level = "Bronze"
	elif score_points <= 2000:
		hero_level = "Prata"
	elif score_points <= 3000:
		hero_level = "Ouro"
	elif score_points <= 4000:
		hero_level = "Platina"
	elif score_points <= 5000:
		hero_level = "Ascendente"
	elif score_points <= 6000:
		hero_level = "Imortal"
	else:
		hero_level = "Radiante"
	
	return hero_level


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enable_menu = true
