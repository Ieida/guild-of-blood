class_name EnemySpawner2D extends Node2D


@export var enemy_scene: PackedScene
@export var interval: float = 1.
@export var max_enemies: int = 10
@onready var game: Game = get_node(^"/root/Game")
var spawned_enemies: Array[Enemy2D]
var previous_spawn_time: float


func _on_enemy_died(enemy: Enemy2D):
	spawned_enemies.erase(enemy)


func _process(_delta: float) -> void:
	if spawned_enemies.size() < max_enemies:
		var et: float = GameUtils.time - previous_spawn_time
		if et >= interval:
			previous_spawn_time = GameUtils.time
			spawn()


func spawn():
	var p: Node = game.current_level.get_node(^"Nodes/Enemies")
	var e: Enemy2D = enemy_scene.instantiate()
	spawned_enemies.append(e)
	e.died.connect(func (): _on_enemy_died(e))
	p.add_child(e)
	e.global_position = global_position
