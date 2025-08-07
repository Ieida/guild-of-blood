class_name Drop2D extends Area2D


@export_range(0., 90.) var attract_amplitude: float = 45.
@export var attract_frequency: float = 5.
@export var attract_velocity: float = 256.
@export var attractor_tags: Array[StringName]
var attractor: Hurtbox2D
var velocity: Vector2


func _physics_process(delta: float) -> void:
	if attractor:
		var dir: Vector2 = global_position.direction_to(
			attractor.global_position
		)
		var ang: float = sin(GameUtils.time * attract_frequency) * deg_to_rad(attract_amplitude)
		dir = dir.rotated(ang)
		var mtn: Vector2 = dir * attract_velocity
		velocity = velocity.move_toward(mtn, 512. * delta)
	else:
		var ang: float = wrapf(GameUtils.time * .5, 0., 1.) * TAU
		var dir: Vector2 = Vector2.RIGHT.rotated(ang)
		var mtn: Vector2 = dir * attract_amplitude
		velocity = velocity.move_toward(mtn, 256. * delta)
		
		for a in get_overlapping_areas():
			if not a is Hurtbox2D: continue
			var has_tag: bool
			for t in attractor_tags:
				if a.tags.has(t):
					has_tag = true
					break
			if not has_tag: continue
			attractor = a
	global_translate(velocity * delta)


func collect():
	queue_free()
