extends Node2D

@onready var spawner: Spawner = $Spawner

# x 28~3950
# y 28~1380
func _ready() -> void:
	spawner.create_wave(100)
