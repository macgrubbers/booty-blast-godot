extends State

class_name IdleState

var character_ref : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	character_ref = char_ref
	
	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	pass
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	character_ref.gravity_apply(delta)
