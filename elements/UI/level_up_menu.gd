extends CanvasLayer

# 327, 199
# 327, 350
# 327, 497
@onready var selector: Panel = $Selector
@export var level_up_menu_active: bool = false
@export var player: Player
var selected: int = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_u"):
		selected -= 1
	elif Input.is_action_just_pressed("move_d"):
		selected += 1

	match selected:
		1:
			selector.position = Vector2(327, 199)
		2:
			selector.position = Vector2(327, 350)
		3:
			selector.position = Vector2(327, 497)
	selected = clampi(selected, 1, 3)

	if !level_up_menu_active: return
	if Input.is_action_just_pressed("attack"):
		level_up_menu_active = false
		upgrade()



func upgrade():
	match selected:
		1:
			player.strenght += 1
		2:
			player.thougness += 1
		3:
			player.speed += 1
	player.update_health()
	get_tree().paused = false
	self.hide()
	get_parent().resume_game()
