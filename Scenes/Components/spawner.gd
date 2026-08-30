class_name Spawner extends Node3D


var x_impulse_range:Vector2
var z_impulse_range:Vector2
var y_impulse_range:Vector2

@export_category("Spawn Variables")
@export var spawning_object:PackedScene
@export var spawn_amount:int = 1
@export var objects_start_physicsable:bool = false ## for physicsable bodies like RigidBody3D
@export var objects_start_activated:bool = false ## for activatable objects like exploding barrels

@export_category("Respawn Behavior")
@export var respawn_timer:Timer	## Leave empty for no respawn
enum respawn_methods{PERIODIC, ON_DEAD_OR_CONSUMED}
@export var respawn_method:respawn_methods = respawn_methods.PERIODIC
@export var start_spawning_on_ready:bool = false


func _ready() -> void:
	if respawn_timer:
		respawn_timer.connect("timeout", _on_respawn_timer_timeout)
		if respawn_method == respawn_methods.ON_DEAD_OR_CONSUMED:
			respawn_timer.set_one_shot(true) # override just in case we forget
		if start_spawning_on_ready:
			await get_tree().current_scene.ready
			spawn()
			toggle_spawning(true)


# TODO: Separate into a "EnemySpawner" "PhysicsObjectSpawner", "StaticObjectSpawner" etc..
func spawn()->Node:
	var new_obj = spawning_object.instantiate()
	new_obj.set_global_transform(get_global_transform())
	if new_obj.has_method("set_physicsable"):
		new_obj.set_physicsable(objects_start_physicsable)
	get_tree().current_scene.add_child(new_obj)
	#if new_obj.has_method("apply_central_impulse"):
		#scatter(new_obj)
	
	handle_interact_object(new_obj) # interact option
	
	setup_respawn_trigger(new_obj) # setup respawn
	
	return new_obj

func toggle_spawning(opt:bool):
	if respawn_timer:
		if opt:
			respawn_timer.start()
		else:
			respawn_timer.stop()

#func scatter(new_obj:Node):
	#new_obj.apply_impulse(Vector3(randf_range(x_impulse_range.x, x_impulse_range.y),
											#randf_range(z_impulse_range.x, z_impulse_range.y),
											#randf_range(y_impulse_range.x, y_impulse_range.y)),
						#Vector3(randf_range(x_impulse_range.x, x_impulse_range.y),
											#randf_range(z_impulse_range.x, z_impulse_range.y),
											#randf_range(y_impulse_range.x, y_impulse_range.y)))

#func set_scatter(new_method:spawn_methods,
					#physicsable:bool,
					#new_x_impulse_range:Vector2,
					#new_y_impulse_range:Vector2,
					#new_z_impulse_range:Vector2):
	#make_physicsable = physicsable
	#x_impulse_range = new_x_impulse_range
	#z_impulse_range = new_y_impulse_range
	#y_impulse_range = new_z_impulse_range

func handle_interact_object(obj:Node):
	# TODO: find a better way to determine if an object can be activated
	# 	Also need to standardize 'interact' and 'activate
	if objects_start_activated and obj.has_method("interact"):
		obj.interact()

func setup_respawn_trigger(obj:Node):
	if respawn_timer and respawn_method == respawn_methods.ON_DEAD_OR_CONSUMED:
		if obj.has_signal("dead"):
			obj.connect("dead", respawn_timer.start)
		elif obj.has_signal("consumed"):
			obj.connect("consumed", respawn_timer.start)


func _on_respawn_timer_timeout():
	spawn()

func activate():
	spawn()
