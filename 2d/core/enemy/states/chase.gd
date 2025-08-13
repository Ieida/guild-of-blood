class_name EnemyStateChase extends State


@export var stop_distance: float = 128.


func evaluate() -> bool:
	if not root.visionbox.target: return false
	if machine.gep(&"is_attack_on_cd"): return false
	return true


func run_physics(delta: float):
	if not root.visionbox.target:
		machine._exit_active_state()
		return
	var tpos: Vector2 = root.visionbox.target.global_position
	var rpos: Vector2 = root.global_position
	if absf(tpos.x - rpos.x) <= stop_distance: return
	var dir: float = 1.0 if tpos.x > rpos.x else -1.0
	root.velocity.x = move_toward(
		root.velocity.x, dir * root.speed, root.acceleration * delta
	)
