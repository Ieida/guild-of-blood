class_name DropSpawner2D extends Node2D


@export var drop_scene: PackedScene
@onready var game: Game = get_node(^"/root/Game")


func spawn():
	var p: Node = game.current_level.get_node(^"Nodes/Drops")
	var d: Drop2D = drop_scene.instantiate()
	p.add_child(d)
	d.global_position = global_position
