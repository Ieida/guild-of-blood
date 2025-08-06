class_name EnemyStateChase extends State


@export var stop_distance: float = 128.


func enter():
	print("enemy entered chase state")


func evaluate() -> bool:
	if not root.target: return false
	if machine.gep(&"is_attack_on_cd"): return false
	return true


func exit():
	print("enemy exited chase state")


func run_physics(delta: float):
	var tpos: Vector2 = root.target.global_position
	var rpos: Vector2 = root.global_position
	if absf(tpos.x - rpos.x) <= stop_distance: return
	var dir: float = 1.0 if tpos.x > rpos.x else -1.0
	root.velocity.x = move_toward(
		root.velocity.x, dir * root.speed, root.acceleration * delta
	)


func start():
	pass
