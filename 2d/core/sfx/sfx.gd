class_name SFX extends FmodEventEmitter2D


@export var delay: float
var start_time: float
var played: bool


func _enter_tree() -> void:
	start_time = GameUtils.time
	stopped.connect(_on_stopped)


func _on_stopped():
	queue_free()


func _process(_delta: float) -> void:
	if not played:
		var et: float = GameUtils.time - start_time
		if et >= delay:
			played = true
			play()
