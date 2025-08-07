class_name BloodCollector2D extends Area2D


@export var radius: float = 32.
@export var ui: Label
var points: int


func _physics_process(_delta: float) -> void:
	for a in get_overlapping_areas():
		if not a is Drop2D: continue
		var dst: float = global_position.distance_to(a.global_position)
		if dst > radius: continue
		pick_up(a)


func _ready() -> void:
	update_ui()


func pick_up(drop: Drop2D):
	drop.collect()
	points += 1
	update_ui()


func update_ui():
	if ui:
		ui.text = str(points)
