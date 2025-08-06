class_name Hitbox2D extends Area2D


@export var active: bool
@export var can_hit_multiple: bool
@export var cooldown: float
@export var damage: float
@export var target_tags: Array[StringName]
var cooldown_start_time: float
var cooldown_elapsed_time: float
var is_on_cooldown: bool


func _process(_delta: float) -> void:
	if is_on_cooldown:
		cooldown_elapsed_time = GameUtils.time - cooldown_start_time
		if cooldown_elapsed_time >= cooldown:
			cooldown_elapsed_time = 0.
			is_on_cooldown = false


func _physics_process(_delta: float) -> void:
	if active and not is_on_cooldown:
		for a in get_overlapping_areas():
			if a is Hurtbox2D:
				var has_target_tag: bool
				for t in target_tags:
					if a.tags.has(t):
						has_target_tag = true
						break
				if not has_target_tag: continue
				hit(a)
				if not can_hit_multiple: break


func hit(hurtbox: Hurtbox2D):
	hurtbox.hurt(damage)
	if not is_zero_approx(cooldown):
		cooldown_start_time = GameUtils.time
		is_on_cooldown = true
