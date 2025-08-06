class_name Hurtbox2D extends Area2D


@export var health: Health
@export var tags: Array[StringName]


func _enter_tree() -> void:
	health.start()


func hurt(damage: float):
	health.reduce(damage)
