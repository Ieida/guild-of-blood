class_name EnemyStateDie extends State


func enter():
	print("enemy entered die state")


func exit():
	print("enemy exited die state")


func evaluate() -> bool:
	if not root.hurtbox.health.is_depleted: return false
	return true


func run(delta: float):
	root.mesh.scale = root.mesh.scale.move_toward(
		Vector2.ONE * 0.1,
		delta
	)
	if root.mesh.scale.length() <= 0.2:
		root.queue_free()
