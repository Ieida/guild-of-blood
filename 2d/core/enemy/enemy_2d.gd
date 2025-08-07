class_name Enemy2D extends CharacterBody2D


signal died
signal landed


@export var acceleration: float = 1024.
@export var attack_cooldown: float = 5.
@export var attack_distance: float = 128.
@export var deceleration: float = 1024.
@export var gravity: float = 313.6
@export var speed: float = 256.
@export var state_machine: StateMachine
@onready var hitbox: Hitbox2D = $Hitbox2D
@onready var hurtbox: Hurtbox2D = $Hurtbox2D
@onready var mesh: MeshInstance2D = $Mesh
@onready var target: Player2D = get_node(^"../../Player2D")
var attack_cooldown_start_time: float


func _on_health_depleted():
	died.emit()


func _on_health_reduced():
	print("Enemy health reduced, health: %s" % hurtbox.health.points)


func _enter_tree() -> void:
	state_machine.root = self
	state_machine.start()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	state_machine.run_physics(delta)
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if is_on_floor() and not was_on_floor: landed.emit()


func _process(delta: float) -> void:
	if state_machine.gep(&"is_attack_on_cd"):
		var et: float = GameUtils.time - attack_cooldown_start_time
		if et > attack_cooldown:
			state_machine.sep(&"is_attack_on_cd", false)
	state_machine.run(delta)


func _ready() -> void:
	hurtbox.health.reduced.connect(_on_health_reduced)
	hurtbox.health.depleted.connect(_on_health_depleted)
