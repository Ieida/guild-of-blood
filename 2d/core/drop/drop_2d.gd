class_name Drop2D extends Area2D


@export_range(0., 90.) var attract_amplitude: float = 45.
@export var attract_frequency: float = 5.
@export var attract_velocity: float = 128.
@export var attractor_tags: Array[StringName]
var attractor: Hurtbox2D


func _physics_process(delta: float) -> void:
	if attractor:
		var dir: Vector2 = global_position.direction_to(
			attractor.global_position
		)
		var ang: float = sin(GameUtils.time * attract_frequency) * deg_to_rad(attract_amplitude)
		dir = dir.rotated(ang)
		var mtn: Vector2 = dir * attract_velocity * delta
		global_translate(mtn)
	else:
		var ang: float = wrapf(GameUtils.time * .5, 0., 1.) * PI * 2.
		var dir: Vector2 = Vector2.RIGHT.rotated(ang)
		var mtn: Vector2 = dir * attract_amplitude * delta
		global_translate(mtn)
		
		for a in get_overlapping_areas():
			if not a is Hurtbox2D: continue
			var has_tag: bool
			for t in attractor_tags:
				if a.tags.has(t):
					has_tag = true
					break
			if not has_tag: continue
			attractor = a


func collect():
	queue_free()
