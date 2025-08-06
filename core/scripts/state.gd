class_name State extends Resource


@export var priority: int
var is_active: bool
var machine: StateMachine
var root: Node


func enter():
	pass


func evaluate() -> bool:
	return false


func exit():
	pass


func run(_delta: float):
	pass


func run_physics(_delta: float):
	pass


func start():
	pass
