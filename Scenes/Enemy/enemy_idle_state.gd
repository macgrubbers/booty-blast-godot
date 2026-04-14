extends State

class_name Enemy_IdleState

var state_name : String = "Idle"

var cR : CharacterBody3D
var perception_component

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	perception_component = cR.perception_component
	perception_component.connect("player_just_found", player_found)
	perception_component.start_tracking()
	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	pass
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	check_if_floor()
	
	cR.gravity_apply(delta)
	
	cR.velocity.x = move_toward(cR.velocity.x,0, delta*20)
	cR.velocity.z = move_toward(cR.velocity.z,0, delta*20)
	
	
func check_if_floor():
	#manage the appliements and state transitions that needs to be sets/checked/performed
	#every time the play char pass through one of the following : floor-inair-onwall
	if !cR.is_on_floor() and !cR.is_on_wall():
		pass
		#transitioned.emit(self, "InairState")
		
			
func player_found():
	print("tryna transition")
	transitioned.emit(self, "Enemy_PursueState")
