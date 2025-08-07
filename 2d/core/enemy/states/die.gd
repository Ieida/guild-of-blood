class_name EnemyStateDie extends State


var start_color: Color
var start_time: float


func enter():
	start_color = root.mesh.modulate
	start_time = GameUtils.time
	root.velocity = Vector2.ZERO
	root.hurtbox.process_mode = Node.PROCESS_MODE_DISABLED


func evaluate() -> bool:
	if not root.hurtbox.health.is_depleted: return false
	return true


func run(delta: float):
	var et: float = GameUtils.time - start_time
	var etp: float = clampf(et / 1., 0., 1.)
	root.mesh.modulate = start_color.lerp(Color.TRANSPARENT, etp)
	if is_equal_approx(etp, 1.):
		root.queue_free()
