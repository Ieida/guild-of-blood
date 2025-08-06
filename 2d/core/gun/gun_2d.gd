class_name Gun2D extends Node2D


@export var bullet_fire_point: Node2D
## Fire rate in Rounds Per Minute
@export var rpm: float = 200.
@onready var bullet_parent: Node2D = $Bullets
@onready var bullet_scene: PackedScene = preload("res://2d/core/bullet/bullet_2d.tscn")
var chamber_start_time: float
var is_chambering: bool
var is_trigger_pressed: bool


func _physics_process(_delta: float) -> void:
	if is_trigger_pressed and not is_chambering:
		_shoot()


func _process(_delta: float) -> void:
	if is_chambering:
		var et: float = GameUtils.time - chamber_start_time
		if et >= 60. / rpm:
			is_chambering = false


func _shoot():
	var b: Bullet2D = bullet_scene.instantiate()
	bullet_parent.add_child(b)
	b.global_position = bullet_fire_point.global_position
	b.global_rotation = bullet_fire_point.global_rotation
	b.fire()
	is_chambering = true
	chamber_start_time = GameUtils.time


func press_trigger():
	is_trigger_pressed = true


func release_trigger():
	is_trigger_pressed = false
