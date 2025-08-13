class_name FootstepSFXPlayer extends Node2D


const SFX_PARENT_PATH: NodePath = ^"Nodes/SpawnedEntities"


@export var frequency: float = 2.
@onready var footstep_scene: PackedScene = preload("res://2d/sfx/footstep/footstep.tscn")
@onready var character: Player2D = $".."
@onready var game: Game = get_node(^"/root/Game/")
var played: bool
var start_time: float


func _on_character_jumped():
	if not character.just_landed and not is_zero_approx(character.velocity.x):
		_play()


func _on_character_landed():
	start_time = GameUtils.time
	_play()
	_play(0.1) # Offset slightly for a better effect


func _on_character_stopped_moving_on_floor():
	_play()


func _play(delay: float = 0.):
	var f: SFX = footstep_scene.instantiate()
	game.current_level.get_node(SFX_PARENT_PATH).add_child(f)
	f.delay = delay
	f.global_position = global_position
	f.play()


func _process(_delta: float) -> void:
	if character.is_on_floor() and not is_zero_approx(character.velocity.x):
		var et: float = GameUtils.time - start_time
		if et >= 1. / frequency:
			start_time = GameUtils.time
			_play()


func _ready() -> void:
	character.jumped.connect(_on_character_jumped)
	character.landed.connect(_on_character_landed)
	character.stopped_moving_on_floor.connect(_on_character_stopped_moving_on_floor)
