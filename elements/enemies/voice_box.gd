extends AudioStreamPlayer2D

@export var playbacks: Array[AudioStreamMP3]
@export var ouch_playbacks: Array[AudioStreamMP3]
@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	var playback = playbacks.pick_random()
	stream = playback
	play()
	timer.start(randf_range(3.0,7.0))

func hurt_sound():
	var playback = ouch_playbacks.pick_random()
	stream = playback
	play()
	timer.start(randf_range(3.0,7.0))
