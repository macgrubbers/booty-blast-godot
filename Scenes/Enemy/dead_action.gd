@tool
class_name DeadAction extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	# Create enemy ragdoll
	var enemy_ragdoll:RigidBody3D = actor.ragdoll.instantiate()
	enemy_ragdoll.set_global_transform(actor.get_global_transform())
	var rand_hit = Vector3(randf_range(-50,50), randf_range(-50,50), randf_range(-50,50))
	enemy_ragdoll.apply_impulse(actor.health_component.last_applied_knockback*1.5)
	enemy_ragdoll.apply_torque(rand_hit)
	get_tree().current_scene.add_child(enemy_ragdoll)
	
	# Create enemy weapon ragdoll
	var new_weapon_ragdoll = actor.weapon_ragdoll.instantiate()
	new_weapon_ragdoll.set_global_transform(actor.weapon.get_global_transform())
	var rand_hit2 = Vector3(randf_range(-50,50), randf_range(-50,50), randf_range(-50,50))
	new_weapon_ragdoll.apply_impulse(actor.health_component.last_applied_knockback*1.5)
	new_weapon_ragdoll.apply_torque(rand_hit2)
	get_tree().current_scene.add_child(new_weapon_ragdoll)
	
	actor.queue_free()
	return SUCCESS
