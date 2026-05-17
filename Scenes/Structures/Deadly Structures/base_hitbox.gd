class_name SpinnyHammer extends BaseHitbox

func _on_area_entered(area: Area3D) -> void:
	super(area)
	var knockback_dir = -global_transform.basis.z.normalized() * knockback_magnitude
	area.apply_knockback(knockback_dir, false)
