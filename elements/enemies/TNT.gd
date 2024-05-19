extends Node2D
 # size = sin(PI * path_pos)
var target_pos: Vector2
var explosion_pos: Vector2
var speed: float = 550.0
@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var animated_sprite_2d: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
const EXPLOSION = preload("res://elements/misc/explosion.tscn")

func _ready() -> void:
	path_2d.curve.set_point_position(1, target_pos)

func _process(delta: float) -> void:
	if !target_pos:
		return
	if path_follow_2d.progress_ratio >= .98:
		var explosion = EXPLOSION.instantiate()
		explosion.global_position = explosion_pos
		get_node("/root/Main").add_child(explosion)
		self.queue_free()
	print(path_2d.curve.get_point_position(1))
	path_follow_2d.progress += speed * delta
	animated_sprite_2d.scale = Vector2(1.0,1.0) * (1.0 + (sin(PI * path_follow_2d.progress_ratio) * 0.7))
