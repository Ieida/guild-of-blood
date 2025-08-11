class_name BloodCollector2D extends Area2D


signal collected


@export var radius: float = 32.
var points: int


func _physics_process(_delta: float) -> void:
	for a in get_overlapping_areas():
		if not a is Drop2D: continue
		var dst: float = global_position.distance_to(a.global_position)
		if dst > radius: continue
		pick_up(a)


func pick_up(drop: Drop2D):
	drop.collect()
	points += 1
	collected.emit()
