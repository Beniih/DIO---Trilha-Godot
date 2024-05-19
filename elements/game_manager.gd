extends Node

signal xp_received(amount)
signal game_over_trigger

var player_position: Vector2
var fator_wave: int = 100
var minutes: int = 0
var nivel: int = 1
var total_xp: int = 0
var gold_count: int = 0
var score: int = 0
var game_over = false

func _process(delta: float) -> void:
	score = total_xp + (minutes * 100) + (gold_count * 10)

func change_dificult():
	var new_dificult = 100.0 * (1.0 + (nivel/10.0) + (minutes/6.0))
	fator_wave = int(new_dificult)

func call_game_over():
	if game_over:
		return
	game_over = true
	game_over_trigger.emit()

func reset():
	player_position = Vector2.ZERO
	fator_wave = 100
	minutes = 0
	nivel = 1
	total_xp = 0
	gold_count = 0
	score = 0
	game_over = false
	for connection in game_over_trigger.get_connections():
		game_over_trigger.disconnect(connection.callable)
