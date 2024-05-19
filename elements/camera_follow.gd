extends Camera2D

@export var target: Player
@export var follow_speed: float = 2.0

func _ready() -> void:
	if target == null:
		if get_parent().has_node("Player"):
			target = get_parent().get_node("Player")

func _process(delta: float) -> void:
	if GameManager.game_over:
		return
	if position.distance_squared_to(target.position) < 1.0:
		return
	position = lerp(position,target.position, follow_speed * delta)
