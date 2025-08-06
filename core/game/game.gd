class_name Game extends Node


@export var default_level: PackedScene
var current_level: Level2D
var start_time: float


func _enter_tree() -> void:
	start_time = GameUtils.time


func _ready() -> void:
	# Load default level at the end
	# so that the level doesn't have
	# to guess if Game is ready
	change_level_to_scene(default_level)


func change_level_to_node(level_node: Level2D):
	if not level_node: return
	if current_level: unload_current_level()
	current_level = level_node
	add_child(level_node)


func change_level_to_scene(level_scene: PackedScene):
	var lvl_node: Level2D = level_scene.instantiate()
	change_level_to_node(lvl_node)


func get_elapsed_time() -> float:
	return GameUtils.time - start_time


func unload_current_level():
	remove_child(current_level)
	current_level.queue_free()
	current_level = null
