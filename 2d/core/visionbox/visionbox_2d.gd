class_name Visionbox2D extends Area2D


@export_range(0., 180.) var angle: float = 75.
@export var follow_node: Node2D
@export var target_tags: Array[StringName]
var face_direction: Vector2
var last_target_position: Vector2
var params: PhysicsRayQueryParameters2D
var target: Hurtbox2D


func _physics_process(_delta: float) -> void:
	if follow_node:
		global_position = follow_node.global_position
		global_rotation = follow_node.global_rotation
	
	if target and not is_target_visible(target):
		target = null
	var idl_tgt: Hurtbox2D = target
	var idl_dst: float = global_position.distance_to(target.global_position) if target else INF
	for a in get_overlapping_areas():
		if a == target or not (a is Hurtbox2D): continue
		# Filter by tags
		var is_tgt: bool
		for t in target_tags:
			if a.tags.has(t):
				is_tgt = true
				break
		if not is_tgt: continue
		# Filter by distance and angle
		var to_a: Vector2 = a.global_position - global_position
		var ang: float = face_direction.angle_to(to_a.normalized())
		if ang > angle or to_a.length() > idl_dst or not is_target_visible(a): continue
		# Set ideal
		idl_dst = to_a.length()
		idl_tgt = a
	target = idl_tgt
	if target:
		last_target_position = target.global_position


func _ready() -> void:
	params = PhysicsRayQueryParameters2D.new()
	params.collision_mask = 1>>0


func is_target_visible(targt: Hurtbox2D) -> bool:
	params.from = global_position
	params.to = targt.global_position
	var dss: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var inf: Dictionary = dss.intersect_ray(params)
	return inf.is_empty()


func set_facing(left: bool):
	face_direction.x = -1.0 if left else 1.0
