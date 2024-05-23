extends AnimatedSprite2D

@export var playbacks: Array[AudioStreamMP3]
@onready var death_fx: AudioStreamPlayer2D = $DeathFX

func _ready() -> void:
	self.animation_finished.connect(free_node)
	death_fx.stream = playbacks.pick_random()
	death_fx.play()

func free_node() -> void:
	self.queue_free()
