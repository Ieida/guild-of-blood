class_name Drop2D extends Area2D


@export var attractor_tags: Array[StringName]
var attractor: Hurtbox2D


func _physics_process(delta: float) -> void:
	if attractor:
		var dir: Vector2 = global_position.direction_to(
			attractor.global_position
		)
		var ang: float = sin(GameUtils.time * 5.) * deg_to_rad(45.)
		dir = dir.rotated(ang)
		var mtn: Vector2 = dir * 64. * delta
		global_translate(mtn)
	else:
		for a in get_overlapping_areas():
			if not a is Hurtbox2D: continue
			var has_tag: bool
			for t in attractor_tags:
				if a.tags.has(t):
					has_tag = true
					break
			if not has_tag: continue
			attractor = a
