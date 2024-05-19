extends Node2D

@onready var spawner: Spawner = $Spawner
@export var game_ui: CanvasLayer
@export var game_over_template: PackedScene

# x 28~3950
# y 28~1380
func _ready() -> void:
	spawner.create_wave(100)
	GameManager.game_over_trigger.connect(trigger_game_over)

func trigger_game_over() -> void:
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	var game_over_ui = game_over_template.instantiate()
	add_child(game_over_ui)
