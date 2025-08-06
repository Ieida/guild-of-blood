extends Node


var time: float
var time_scale: float = 1.


func _process(delta: float) -> void:
	time += delta * time_scale


func get_unscaled_time() -> float:
	return time / time_scale
