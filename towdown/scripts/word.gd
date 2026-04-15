extends Node2D


const ENEMY = preload("uid://bqdg2v8pedhk5")
@onready var player: Player = $Player

func spawnEnemy():
	var enemy = ENEMY.instantiate()
	
	var random_angle: float = randf() * PI * 2
	var spawnDistance: float = randf_range(270, 300)
	var spawn_offset : Vector2 = Vector2(cos(random_angle), sin(random_angle)) * spawnDistance


	enemy.position = spawn_offset + player.position
	add_child(enemy)


func _ready() -> void:
	spawnEnemy()
