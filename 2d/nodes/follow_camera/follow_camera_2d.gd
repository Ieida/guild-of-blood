class_name FollowCamera2D extends Camera2D


@export var follow_target: Node2D
@export var max_distance: float = 512.
@export var velocity_influence_x: float = .5
@export var velocity_influence_y: float = .25


func _process(_delta: float) -> void:
	if follow_target:
		var target_pos: Vector2 = follow_target.global_position
		if follow_target is CharacterBody2D:
			var v: Vector2 = follow_target.velocity
			target_pos += Vector2(
				v.x * velocity_influence_x,
				v.y * velocity_influence_y
			)
		elif follow_target is RigidBody2D:
			var v: Vector2 = follow_target.linear_velocity
			target_pos += Vector2(
				v.x * velocity_influence_x,
				v.y * velocity_influence_y
			)
		var vec_to_target: Vector2 = target_pos - global_position
		var dstp: float = vec_to_target.length() / max_distance
		global_position = global_position.lerp(
			target_pos,
			maxf(dstp * dstp, 0.1)
		)
