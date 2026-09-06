class_name ExplodingBarrel extends RigidBody3D

@onready var fuse_duration:float = 3.0

@onready var shape_cast: ShapeCast3D = $ShapeCast3D
@onready var health_component:PropHealthComponent = $PropHealthComponent

func _ready() -> void:
	health_component.connect("dead", start_fuse)


func start_fuse():
	# Start fuse, wait for it to expire
	$FuseParticles.emitting = true
	$Fuse.start()
	await $Fuse.timeout
	detonate()

func detonate():
	$FuseParticles.emitting = false
	$ExplosionParticles.emitting = true
	$Meshes.visible = false
	$CollisionShape3D.disabled = true
	activate()
	await $ExplosionParticles.finished
	queue_free()


func activate():
	shape_cast.force_shapecast_update()
	var num_colliders = shape_cast.get_collision_count()
	var extra_vertical_knockback:Vector3 = Vector3(0,2,0)
	var knockback_magnitude:float = 10
	for i in num_colliders:
		var collider = shape_cast.get_collider(i)
		var global_collision_point = shape_cast.get_collision_point(i)
		var knockback_dir = global_position.direction_to(global_collision_point) + extra_vertical_knockback
		var knockback_vec = knockback_dir * knockback_magnitude
		if collider is HealthComponent:
			collider.attack(10, 2, self, knockback_vec)
		elif collider is RigidBody3D:
			collider.apply_impulse(knockback_vec, collider.to_local(global_collision_point))
