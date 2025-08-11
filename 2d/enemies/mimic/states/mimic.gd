class_name EnemyStateMimicAttack extends State


const INTERVAL: float = 0.2


@export var delay: float = 0.5
@export var speed: float = 64.
var attack_start_time: float
var can_attack: bool = true
var interval_start_time: float
var movements: Array[Vector2]
var prev_target_pos: Vector2
var target_motion: Vector2


func enter():
	attack_start_time = GameUtils.time
	interval_start_time = GameUtils.time
	prev_target_pos = root.visionbox.target.global_position
	root.hitbox.active = true


func evaluate() -> bool:
	if not can_attack: return false
	var tgt: Hurtbox2D = root.visionbox.target
	if not tgt: return false
	if machine.gep(&"is_attack_on_cd"): return false
	var diff: Vector2 = tgt.global_position - root.global_position
	if absf(diff.x) > root.attack_distance: return false
	return true


func exit():
	root.hitbox.active = false


func run_physics(delta: float):
	var t: float = GameUtils.time
	var et: float = t - attack_start_time
	var iet: float = t - interval_start_time
	if iet >= INTERVAL:
		interval_start_time = t
		var tpos: Vector2 = root.visionbox.target.global_position
		var mtn = tpos - prev_target_pos
		movements.append(mtn)
		prev_target_pos = tpos
		if et >= delay:
			target_motion = movements.pop_front()
	if not is_zero_approx(target_motion.x):
		var dir: float = 1.0 if target_motion.x > 0.0 else -1.0
		var vel: Vector2 = Vector2(
			dir * speed,
			root.velocity.y
		)
		root.velocity = root.velocity.move_toward(
			vel, root.acceleration * delta
		)
	elif target_motion.y < 0. and root.is_on_floor():
		var tgt: Player2D = root.visionbox.target.get_parent()
		root.velocity.y = -sqrt(2. * absf(root.gravity) * tgt.jump_height)
	elif root.is_on_floor():
		root.velocity.x = move_toward(
			root.velocity.x, 0., root.deceleration * delta
		)
	var dst: float = root.global_position.distance_to(
		root.visionbox.target.global_position
	)
	if dst > root.attack_distance * 2.:
		machine._exit_active_state()
