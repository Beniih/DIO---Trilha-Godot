extends Node2D

@onready var aura_collision: Area2D = $AuraCollision
@onready var slap: AudioStreamPlayer2D = $Slap


func aura_damage():
	var bodies = aura_collision.get_overlapping_bodies()
	for body in bodies:
		if !is_instance_valid(body):
			return
		if body.is_in_group("enemy"):
			slap.play(.2)
			var nivel: int = GameManager.nivel
			var dmg: int = 1 + floori(nivel / 2)
			body.take_damage(dmg, true)
