extends Camera2D

@export var target: Player
@export var follow_speed: float = 2.0

func _ready() -> void:
	if target == null:
		if get_parent().has_node("Player"):
			target = get_parent().get_node("Player")

func _process(delta: float) -> void:
	position = lerp(position,target.position, follow_speed * delta)
