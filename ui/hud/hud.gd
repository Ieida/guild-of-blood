class_name HUD extends MarginContainer


@onready var blood_count: Label = $Blood/BloodCount
@onready var health_bar: ProgressBar = $Health/PanelContainer/ProgressBar


func set_blood(val: int):
	blood_count.text = str(val)


func set_health(val: float):
	health_bar.value = val * 100.
