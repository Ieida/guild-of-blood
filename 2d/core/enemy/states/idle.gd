class_name EnemyStateIdle extends State


func evaluate() -> bool:
	return true


func run_physics(delta: float):
	if root.is_on_floor():
		root.velocity.x = move_toward(
			root.velocity.x, 0., root.deceleration * delta
		)
