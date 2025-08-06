class_name Health extends Resource


signal depleted
signal filled
signal increased
signal reduced


@export var max_points: float
@export var points: float
var is_depleted: bool
var is_full: bool


func increase(amount: float):
	if is_full: return
	points += amount
	if is_equal_approx(points, max_points):
		points = max_points
		is_full = true
		filled.emit()
	increased.emit()


func reduce(amount: float):
	if is_depleted: return
	points -= amount
	if is_zero_approx(points):
		points = 0.
		is_depleted = true
		depleted.emit()
	reduced.emit()


func start():
	is_depleted = is_zero_approx(points)
	points = 0.
	is_full = is_equal_approx(points, max_points)
	points = max_points
