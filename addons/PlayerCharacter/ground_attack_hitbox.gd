class_name GroundAttackHitbox extends PlayerBaseHitbox


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	super._ready()

func _on_body_entered(body:Node3D):
	global_collision_point = check_shape_cast()
	knockback_dir = global_position.direction_to(global_collision_point) + Vector3(0,.2,0)
	knockback_magnitude = 10
	super._on_body_entered(body)
	return
