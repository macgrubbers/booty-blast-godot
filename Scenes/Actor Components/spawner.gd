class_name Spawner extends Node3D

enum spawn_methods{DROP, SCATTER}
var current_spawn_method:spawn_methods = spawn_methods.DROP
var make_physicsable:bool = false
var x_impulse_range:Vector2
var z_impulse_range:Vector2
var y_impulse_range:Vector2

# TODO: Separate into a "EnemySpawner" "PhysicsObjectSpawner", "StaticObjectSpawner" etc..
func spawn(obj_type: PackedScene, amount:int = 1):
	for i in range(amount):
		var new_obj = obj_type.instantiate()
		new_obj.set_global_transform(get_global_transform())
		if new_obj.has_method("set_physicsable"):
			new_obj.set_physicsable(make_physicsable)
		get_tree().current_scene.add_child(new_obj)
		if current_spawn_method == spawn_methods.SCATTER and new_obj.has_method("apply_central_impulse"):
			new_obj.apply_central_impulse(Vector3(randf_range(x_impulse_range.x, x_impulse_range.y),
													randf_range(z_impulse_range.x, z_impulse_range.y),
													randf_range(y_impulse_range.x, y_impulse_range.y)))

func set_spawn_method(new_method:spawn_methods,
					physicsable:bool,
					new_x_impulse_range:Vector2,
					new_y_impulse_range:Vector2,
					new_z_impulse_range:Vector2):
	current_spawn_method = new_method
	make_physicsable = physicsable
	x_impulse_range = new_x_impulse_range
	z_impulse_range = new_y_impulse_range
	y_impulse_range = new_z_impulse_range
