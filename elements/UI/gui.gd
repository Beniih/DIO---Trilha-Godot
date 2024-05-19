extends CanvasLayer

@onready var timer_label: Label = $TimerLabel
@onready var gold_count: Label = $GoldPanel/GoldCount
@onready var score_count: Label = $ScorePanel/ScoreCount
@onready var nivel: Label = $NivelPanel/Nivel


var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	if GameManager.game_over:
		return

	time_elapsed += delta
	var time_elapsed_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_seconds % 60
	var minutes: int = int(time_elapsed_seconds / 60.0)
	GameManager.minutes = minutes
	timer_label.text = "%02d:%02d" % [minutes, seconds]

	gold_count.text = str(GameManager.gold_count)
	score_count.text = str(GameManager.score)
	nivel.text = str(GameManager.nivel)
