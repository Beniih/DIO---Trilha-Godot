extends AnimatedSprite2D

func _ready() -> void:
	self.animation_finished.connect(free_node)

func free_node() -> void:
	self.queue_free()
