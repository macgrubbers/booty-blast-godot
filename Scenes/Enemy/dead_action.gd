@tool
class_name DeadAction extends ActionLeaf

@onready var health_component: HealthComponent = $"../../../HealthComponent"

func before_run(actor: Node, blackboard: Blackboard) -> void:
	$"../../../VisualRoot/LilGooberVisuals".state_machine.stop()
	$"../../../VisualRoot/LilGooberVisuals".attack_state_machine.stop()
	$"../../../VisualRoot/LilGooberVisuals".bone_simulator.set_active(true)
	$"../../../VisualRoot/LilGooberVisuals".bone_simulator.physical_bones_start_simulation()
	$"../../../VisualRoot/LilGooberVisuals".apply_impulse_to_ragdoll(health_component.last_applied_knockback + Vector3(0,3,0))


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply()
	# Create enemy ragdoll
	#var enemy_ragdoll:RigidBody3D = actor.ragdoll.instantiate()
	#enemy_ragdoll.set_global_transform(actor.get_global_transform())
	#var rand_hit = Vector3(randf_range(-50,50), randf_range(-50,50), randf_range(-50,50))
	#enemy_ragdoll.apply_impulse(actor.health_component.last_applied_knockback*1.5)
	#enemy_ragdoll.apply_torque(rand_hit)
	#get_tree().current_scene.add_child(enemy_ragdoll)
	#
	#actor.queue_free()
	return RUNNING
