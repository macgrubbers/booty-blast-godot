class_name BaseHitbox extends Area3D

@export var duration_timer: Timer
@export var damage: int = 1
@export var knockback_magnitude: float
@onready var knockback_dir: Vector3

signal attack_successful

func _ready() -> void:
	connect("area_entered",_on_area_entered)
	if duration_timer:
		duration_timer.connect("timeout", _on_duration_timer_timeout)


func _on_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		#var player_pos = area.get_parent().get_global_position()
		area.attack(damage, owner, knockback_dir * knockback_magnitude)
		#var k_scale = 10
		#var knockback_vec = global_position.direction_to(player_pos).normalized() * k_scale \
				 #+ Vector3(0,k_scale,0)
		#area.apply_knockback(knockback_magnitude * knockback_dir, true)
		attack_successful.emit()
		return
	return

func activate_for_set_time(duration:float):
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	monitoring = true

func _on_duration_timer_timeout():
	monitoring = false
	
func set_knockback_magnitude(new_knockback:float):
	knockback_magnitude = new_knockback
	
func set_knockback_direction(new_dir:Vector3):
	knockback_dir = new_dir

func toggle(opt:bool):
	monitoring = opt
	# TODO: do a physics query
	await get_tree().physics_frame
	await get_tree().physics_frame
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		_on_area_entered(area)
