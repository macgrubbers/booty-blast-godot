extends Node3D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var attack_state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/AttackStateMachine/playback")
@onready var bone_simulator:PhysicalBoneSimulator3D = $lil_goober_hostile/Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var root_bone:PhysicalBone3D = $"lil_goober_hostile/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone pelvis"

func play_run():
	state_machine.travel("Run")

func play_attack():
	attack_state_machine.start("attack")

func apply_impulse_to_ragdoll(amount:Vector3):
	await get_tree().physics_frame
	root_bone.apply_impulse(amount)
