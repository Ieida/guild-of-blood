class_name EnemyStateRun extends State


@export var distance: float = 128.


func evaluate() -> bool:
	if not root.target: return false
	if not machine.gep(&"is_attack_on_cd"): return false
	var diff: Vector2 = root.target.global_position - root.global_position
	if absf(diff.x) > distance: return false
	return true


func run_physics(delta: float):
	if root.is_on_floor():
		var tpos: Vector2 = root.target.global_position
		var rpos: Vector2 = root.global_position
		if absf(tpos.x - rpos.x) > distance:
			root.velocity.x = move_toward(
				root.velocity.x, 0., root.deceleration * delta
			)
		else:
			var dir: float = -1.0 if tpos.x > rpos.x else 1.0
			root.velocity.x = move_toward(
				root.velocity.x, dir * root.speed, root.acceleration * delta
			)
