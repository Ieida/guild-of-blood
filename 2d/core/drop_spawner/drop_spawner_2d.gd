class_name DropSpawner2D extends Node2D


@export var amount: int = 10
@export var drop_scene: PackedScene
@onready var game: Game = get_node(^"/root/Game")


func spawn():
	for i in amount:
		var p: Node = game.current_level.get_node(^"Nodes/Drops")
		var d: Drop2D = drop_scene.instantiate()
		p.add_child(d)
		d.global_position = global_position
		d.velocity = Vector2.RIGHT.rotated(randf_range(0., TAU)) * randf() * 256.
