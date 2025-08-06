class_name EnemyStateAttack extends State


var can_attack: bool = true


func _on_landed():
	can_attack = true
	if machine.active_state == self:
		root.hitbox.active = false
		machine._exit_active_state()


func enter():
	# lunge
	root.attack_cooldown_start_time = GameUtils.time
	can_attack = false
	machine.sep(&"is_attack_on_cd", true)
	var tpos: Vector2 = root.target.global_position
	var rpos: Vector2 = root.global_position
	tpos.y = rpos.y
	root.velocity += Vector2.UP * 128.
	root.hitbox.active = true
	print("enemy entered attack state")


func evaluate() -> bool:
	if not can_attack: return false
	if not root.target: return false
	if machine.gep(&"is_attack_on_cd"): return false
	var diff: Vector2 = root.target.global_position - root.global_position
	if absf(diff.x) > root.attack_distance: return false
	return true


func exit():
	root.hitbox.active = false
	print("enemy exited attack state")


func run_physics(delta: float):
	if root.is_on_floor():
		root.velocity.x = move_toward(
			root.velocity.x, 0., root.deceleration * delta
		)


func start():
	root.landed.connect(_on_landed)
