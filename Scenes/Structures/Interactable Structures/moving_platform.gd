@tool
class_name MovingPlatform extends Path3D

@export var travel_time := 1.0
@export var loop_path := false

@onready var follower:PathFollow3D = $PathFollow3D

var point_index := 0
var is_moving:bool = false
var waypoint_ratios: Array[float] = []


func _ready() -> void:
	# One ratio per Curve3D control point: 0 = first, 1 = last.
	var point_count := curve.point_count
	if point_count < 2:
		push_warning("MovingPlatform needs at least two Curve3D points.")
		return

	for i in range(point_count):
		waypoint_ratios.append(float(i) / float(point_count - 1))

	follower.progress_ratio = waypoint_ratios[point_index]


func activate() -> void:
	if is_moving or waypoint_ratios.is_empty():
		return

	var next_index := point_index + 1

	if next_index >= waypoint_ratios.size():
		if not loop_path:
			return
		next_index = 0

	is_moving = true

	var tween := create_tween()
	tween.tween_property(
		follower,
		"progress_ratio",
		waypoint_ratios[next_index],
		travel_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	point_index = next_index
	is_moving = false
