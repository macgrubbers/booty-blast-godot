class_name BaseHitbox extends Area3D

@export var duration_timer: Timer
@export var damage: int = 1
@export var target_groups: Array[String]
#var debug_shape:Shape3D

signal attack_successful

func _ready() -> void:
	connect("area_entered",_on_area_entered)
	if duration_timer:
		duration_timer.connect("timeout", _on_duration_timer_timeout)



func _on_area_entered(area: Area3D) -> void:
	if target_groups.size() == 0:
		return
	for group in target_groups:
		if area.get_parent().is_in_group(group) and (area is HealthComponent):
			var player_pos = area.get_parent().get_global_position()
			area.change_health(-damage)
			var k_scale = 10
			var knockback_vec = global_position.direction_to(player_pos).normalized() * k_scale \
					 + Vector3(0,k_scale,0)
			area.apply_knockback(knockback_vec, true)
			attack_successful.emit()
		else:
			return

func activate_for_set_time(duration:float):
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	monitoring = true

func _on_duration_timer_timeout():
	monitoring = false
	
