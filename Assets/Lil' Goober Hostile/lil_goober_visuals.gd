extends Node3D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var attack_state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/AttackStateMachine/playback")



func play_run():
	state_machine.travel("Run")

func play_attack():
	attack_state_machine.start("attack")
