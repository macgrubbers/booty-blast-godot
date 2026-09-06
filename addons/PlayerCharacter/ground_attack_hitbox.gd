class_name HipCheckHitbox extends BaseHitbox

var global_collision_point:Vector3
@export_range(0,1) var camera_shake_intensity:float
@export var shape_cast: ShapeCast3D
@export var collision_shape: CollisionShape3D
@export var camera_root: SpringArm3D


func _ready() -> void:
	# Setup shapecast
	if shape_cast:
		shape_cast.set_shape(collision_shape.get_shape())
		shape_cast.collision_mask = collision_mask
		shape_cast.collide_with_areas = true
		shape_cast.collide_with_bodies = true
		shape_cast.enabled = false


func _on_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		calculate_knockback_dir()
		if !is_zero_approx(camera_shake_intensity):
			camera_root.add_trauma(camera_shake_intensity)
	super._on_area_entered(area)

func calculate_knockback_dir():
	shape_cast.force_shapecast_update()
	global_collision_point = shape_cast.get_collision_point(0)
	knockback_dir = global_position.direction_to(global_collision_point) + extra_vertical_knockback
