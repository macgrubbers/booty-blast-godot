class_name PlayerBaseHitbox extends BaseHitbox

var global_collision_point:Vector3
var extra_vertical_knockback:Vector3

@export var shape_cast: ShapeCast3D
@export var collision_shape: CollisionShape3D

func _ready() -> void:
	setup_shape_cast()
	connect("body_entered", _on_body_entered)
	super._ready()

func setup_shape_cast():
	if shape_cast:
		shape_cast.set_shape(collision_shape.get_shape())
		shape_cast.collision_mask = collision_mask
		shape_cast.collide_with_areas = true
		shape_cast.collide_with_bodies = true
		shape_cast.enabled = false

func _on_body_entered(body:Node3D):
	print(body)
	calculate_knockback_dir()
	body.attack(-damage, knockback_dir * knockback_magnitude, global_collision_point)
	return

func _on_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		calculate_knockback_dir()
	super._on_area_entered(area)

func calculate_knockback_dir():
	shape_cast.force_shapecast_update()
	global_collision_point = shape_cast.get_collision_point(0)
	knockback_dir = global_position.direction_to(global_collision_point) + extra_vertical_knockback
