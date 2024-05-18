class_name Spawner
extends Node2D

@onready var anchor_1: Node2D = $Anchor1 # anchor points to bound the area
@onready var anchor_2: Node2D = $Anchor2 # of the mob spawn
@onready var screen_check: VisibleOnScreenNotifier2D = $ScreenCheck
@onready var timer: Timer = $Timer


@export var monster_listt: Array[PackedScene]
var wave: Array

func create_wave(factor: int):
	var i = factor
	while i > 0:
		var monster: Enemy = monster_listt.pick_random().instantiate()
		if monster.health > i:
			pass
		else:
			wave.append(monster)
			i -= monster.health
	timer.wait_time = 60.0 / float(wave.size())
	timer.start()

func spawn_monster() -> void:
	if !wave.is_empty():
		var spawn_position = pick_point()
		screen_check.position = spawn_position
		await  get_tree().process_frame #wait a frame to avoid unexpected behavior
		while screen_check.is_on_screen(): # avoid spawn mob on the screen
			spawn_position = pick_point()
			screen_check.position = spawn_position
			await  get_tree().process_frame #wait 1 frame to avoid freezing
		var monster = wave[0]
		monster.position = spawn_position
		self.get_parent().add_child(monster)
		wave.pop_front()
		timer.start()

func pick_point() -> Vector2:
	randomize()
	var point: Vector2 = Vector2()
	point.x = randi_range(anchor_1.position.x, anchor_2.position.x)
	point.y = randi_range(anchor_1.position.y, anchor_2.position.y)
	return point


func _on_timer_timeout() -> void:
	if wave.is_empty(): # start a new wave
		GameManager.change_dificult()
		create_wave(GameManager.fator_wave)
	spawn_monster()
