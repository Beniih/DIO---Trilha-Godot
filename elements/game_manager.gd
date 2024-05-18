extends Node

signal xp_received(amount)

var player_position: Vector2
var fator_wave: int = 100
var minutes: int = 0
var nivel: int = 1
var total_xp: int = 0
var gold_count: int = 0
var score: int = 0


func _process(delta: float) -> void:
	score = total_xp + (minutes * 100) + (gold_count * 10)

func change_dificult():
	var new_dificult = 100.0 * (1.0 + (nivel/10.0) + (minutes/6.0))
	fator_wave = int(new_dificult)
