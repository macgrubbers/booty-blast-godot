extends State

class_name TalkingState

var state_name : String = "Talking"

var cR : CharacterBody3D
var player_dialogue_manager

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	player_dialogue_manager = char_ref.player_dialogue_manager
	cR.velocity = Vector3.ZERO
	
	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	cR.godot_plush_skin.set_state("idle")
	
	
func physics_update(delta : float):
	input_management()

			
func input_management():
	if Input.is_action_just_pressed("f"):
		player_dialogue_manager.end_conversation()
		transitioned.emit(self,"IdleState")
