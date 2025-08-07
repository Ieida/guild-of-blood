class_name Player2D extends CharacterBody2D


@export var acceleration: float = 512.
@export var deceleration: float = 256.
@export var gravity: float = 313.6
@export var jump_height: float = 96.
@export var speed: float = 128.
@onready var hurtbox: Hurtbox2D = $Hurtbox2D
@onready var mesh: MeshInstance2D = $Mesh
var modulate_tween: Tween


func _on_health_reduced():
	if modulate_tween: modulate_tween.stop()
	modulate = Color.WHITE
	modulate_tween = create_tween()
	modulate_tween.tween_property(self, ^"modulate", Color.DARK_RED, 0.)
	modulate_tween.finished.connect(_on_modulate_tween_finished)


func _on_modulate_tween_finished():
	modulate_tween = create_tween()
	modulate_tween.tween_property(self, ^"modulate", Color.WHITE, 0.2)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	elif Input.is_action_pressed(&"jump"):
		velocity.y = -sqrt(2. * absf(gravity) * jump_height)
	var input: float = Input.get_axis(&"move_left", &"move_right")
	var motion: float = input * speed
	if not is_zero_approx(input):
		velocity.x = move_toward(velocity.x, motion, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x , 0., deceleration * delta)
	move_and_slide()
	if not is_zero_approx(input):
		mesh.scale.x = 1.0 if input > 0. else -1.


func _ready() -> void:
	hurtbox.health.reduced.connect(_on_health_reduced)
