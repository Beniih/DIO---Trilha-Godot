extends Node

signal xp_received(amount)

var player_position: Vector2
var fator_wave: int = 100
var minutes: int = 0

func change_dificult(nivel: int):
	var new_dificult = 100.0 * (1.0 + (nivel/10.0) + (minutes/6.0))
	fator_wave = int(new_dificult)
