class_name EnemyStateAttack extends State


@export var lunge_velocity_x: float = 256.
@export var lunge_velocity_y: float = 128.
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
	var tpos: Vector2 = root.visionbox.target.global_position
	var rpos: Vector2 = root.global_position
	tpos.y = rpos.y
	root.velocity.y -= lunge_velocity_y
	if absf(root.velocity.x) <= lunge_velocity_x:
		var d: float = 1.0 if tpos.x > rpos.x else -1.0
		root.velocity.x = d * lunge_velocity_x
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
	if root.is_on_floor():
		root.velocity.x = move_toward(
			root.velocity.x, 0., root.deceleration * delta
		)


func start():
	root.landed.connect(_on_landed)
