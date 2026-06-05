class_name LedgeGrabState extends State

var state_name = "LedgeGrabState"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref

	verifications()
	
func verifications():
	pass
	
func _physics_process(delta: float) -> void:
	if cR:
		cR.velocity = Vector3.ZERO
