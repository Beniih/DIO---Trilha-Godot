extends Node2D

@onready var spawner: Spawner = $Spawner
@export var game_ui: CanvasLayer
@export var game_over_template: PackedScene
@export var level_up_menu: CanvasLayer
# x 28~3950
# y 28~1380
func _ready() -> void:
	spawner.create_wave(100)
	GameManager.game_over_trigger.connect(trigger_game_over)
	GameManager.level_up.connect(level_up_trigger)

func trigger_game_over() -> void:
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	var game_over_ui = game_over_template.instantiate()
	add_child(game_over_ui)

func level_up_trigger():
	get_tree().paused = true
	game_ui.hide()
	level_up_menu.show()
	await get_tree().create_timer(1.5).timeout
	level_up_menu.level_up_menu_active = true

func resume_game():
	game_ui.show()
