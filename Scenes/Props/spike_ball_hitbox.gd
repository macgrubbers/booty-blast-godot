# Spike ball hitbox
extends BaseHitbox

func _on_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		print("Collide!")
		#var collider = area.get_owner()
		#var collider_velocity = collider.get_velocity()
		var velocity:Vector3 = get_owner().get_linear_velocity()
		#var dir_to_target = get_owner().get_global_position().direction_to(collider.get_global_position())
		if velocity.length() > 1:
			damage = 3
		else:
			damage = 1
		
	
	super(area)
