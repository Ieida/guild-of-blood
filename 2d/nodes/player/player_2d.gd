class_name Player2D extends CharacterBody2D


signal jumped
signal landed
signal stopped_moving_on_floor


@export var acceleration: float = 512.
@export var deceleration: float = 256.
@export var gravity: float = 313.6
@export var jump_height: float = 96.
@export var speed: float = 128.
@onready var blood_collector: BloodCollector2D = $BloodCollector2D
@onready var hud: HUD = $UI/HUD
@onready var hurtbox: Hurtbox2D = $Hurtbox2D
@onready var mesh: MeshInstance2D = $Mesh
@onready var gdbot: GDBot = $Mesh/GDBot
var just_landed: bool
var modulate_tween: Tween


func _on_blood_collected():
	hud.set_blood(blood_collector.points)


func _on_health_reduced():
	hud.set_health(hurtbox.health.points / hurtbox.health.max_points)
	if modulate_tween: modulate_tween.stop()
	modulate = Color.WHITE
	modulate_tween = create_tween()
	modulate_tween.tween_property(self, ^"modulate", Color.DARK_RED, 0.)
	modulate_tween.finished.connect(_on_modulate_tween_finished)


func _on_modulate_tween_finished():
	modulate_tween = create_tween()
	modulate_tween.tween_property(self, ^"modulate", Color.WHITE, 0.2)


func _physics_process(delta: float) -> void:
	if just_landed: just_landed = false
	var was_on_floor: bool = is_on_floor()
	var was_moving_on_floor: bool = is_on_floor() and not is_zero_approx(velocity.x)
	if not is_on_floor():
		velocity.y += gravity * delta
	elif Input.is_action_pressed(&"jump"):
		velocity.y = -sqrt(2. * absf(gravity) * jump_height)
		jumped.emit()
	var input: float = Input.get_axis(&"move_left", &"move_right")
	var motion: float = input * speed
	if not is_zero_approx(input):
		velocity.x = move_toward(velocity.x, motion, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x , 0., deceleration * delta)
	move_and_slide()
	gdbot.is_in_air = not is_on_floor()
	gdbot.is_running = not is_zero_approx(input)
	if not is_zero_approx(input):
		mesh.scale.x = 1.0 if input > 0. else -1.
	# Landed
	if not was_on_floor and is_on_floor():
		just_landed = true
		landed.emit()
	# Stopped moving on floor
	if was_moving_on_floor and is_on_floor() and is_zero_approx(velocity.x):
		stopped_moving_on_floor.emit()


func _ready() -> void:
	hurtbox.health.reduced.connect(_on_health_reduced)
	blood_collector.collected.connect(_on_blood_collected)
	hud.set_health(hurtbox.health.points / hurtbox.health.max_points)
	hud.set_blood(blood_collector.points)
