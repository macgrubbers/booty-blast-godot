extends Node3D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var attack_state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/AttackStateMachine/playback")
@onready var bone_simulator:PhysicalBoneSimulator3D = $lil_goober_hostile/Armature/Skeleton3D/PhysicalBoneSimulator3D

signal toggle_hitbox(bool)
signal attack_finished

func play_run():
	state_machine.travel("Run")

func play_attack():
	attack_state_machine.start("attack")

func toggle_dance(opt:bool):
	if opt:
		state_machine.travel("Dance")
	else:
		state_machine.stop()

func apply_impulse_to_ragdoll(amount:Vector3):
	if bone_simulator.is_simulating_physics():
		for child in bone_simulator.get_children():
			if child is PhysicalBone3D and randi_range(0,1):
				child.apply_impulse(amount * 5)

func start_hitbox():
	toggle_hitbox.emit(true)
	
func stop_hitbox():
	toggle_hitbox.emit(false)

func attack_animation_finished():
	attack_finished.emit()
