class_name BaseHitbox extends Area3D

@export var duration_timer: Timer
@onready var damage:int = 1

#var debug_shape:Shape3D

signal attack_successful

func _ready() -> void:
	connect("area_entered",_on_area_entered)
	if duration_timer:
		duration_timer.connect("timeout", _on_duration_timer_timeout)
	else:
		monitoring = true


func _on_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Player"):
		var player_pos = area.get_parent().get_global_position()
		area.change_health(-damage,global_position)
		var k_scale = 10
		var knockback_vec = global_position.direction_to(player_pos).normalized() * k_scale \
				 + Vector3(0,k_scale,0)
		area.apply_knockback(knockback_vec, true)
		attack_successful.emit()

func activate_for_set_time(duration:float):
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	monitoring = true

func _on_duration_timer_timeout():
	monitoring = false
	
