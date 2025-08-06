class_name Bullet2D extends Node2D


@export var avoid_tags: Array[StringName]
@export var damage: float = 50.
@export var initial_velocity: float = 2048.
@export var radius: float = 4.
var params: PhysicsShapeQueryParameters2D
var velocity: Vector2


func _impacted(collider: Object):
	var prnt: Node = collider.get_parent()
	if collider is Hurtbox2D:
		var has_avoid_tag: bool
		for t in avoid_tags:
			if collider.tags.has(t):
				has_avoid_tag = true
				break
		if not has_avoid_tag:
			collider.hurt(damage)
			if prnt is RigidBody3D:
				prnt.apply_central_impulse(velocity * 0.005)
			queue_free()


func _physics_process(delta: float) -> void:
	var movement: Vector2 = velocity * delta
	params.transform = global_transform
	params.motion = movement
	var dss: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var cstinf: PackedFloat32Array = dss.cast_motion(params)
	if not is_equal_approx(cstinf[1], 1.):
		var t: Transform2D = global_transform
		t = t.translated(movement * cstinf[1])
		params.transform = t
		var rstinf: Dictionary = dss.get_rest_info(params)
		if not rstinf.is_empty():
			var cldr_id: int = rstinf["collider_id"]
			var cldr: Object = instance_from_id(cldr_id)
			_impacted(cldr)
	global_translate(movement)
	if global_position.length() > 1000.:
		queue_free()


func fire() -> void:
	params = PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas = true
	params.collision_mask = 0b101
	params.shape = CircleShape2D.new()
	params.shape.radius = radius
	velocity = Vector2.RIGHT.rotated(global_rotation) * initial_velocity
