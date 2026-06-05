class_name HurtShapeCast extends ShapeCast3D

@export var shape_radius:float
@export var damage:int
@export var knockback_magnitude:float
@export var extra_vertical_knockback: Vector3 = Vector3(0,1,0)

var explosion_shape:SphereShape3D


func _ready() -> void:
	shape = SphereShape3D.new()
	shape.set_radius(shape_radius)


func activate():
	force_shapecast_update()
	var num_colliders = get_collision_count()
	for i in num_colliders:
		var collider = get_collider(i)
		var global_collision_point = get_collision_point(i)
		var knockback_dir = global_position.direction_to(global_collision_point) + extra_vertical_knockback
		var knockback_vec = knockback_dir * knockback_magnitude
		if collider is HealthComponent:
			collider.attack(damage, get_owner(), knockback_vec, 1.0)
		elif collider is RigidBody3D:
			collider.apply_impulse(knockback_vec, collider.to_local(global_collision_point))
