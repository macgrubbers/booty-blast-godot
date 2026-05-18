class_name StunnedState extends State

var state_name : String = "Stunned"

var cR : CharacterBody3D
@onready var stun_timer : Timer = $StunTimer

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	stun_timer.start()

	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	cR.godot_plush_skin.set_state("inair")
	
	
func physics_update(delta : float):
	cR.gravity_apply(delta)
	# dampen
	cR.velocity.x = move_toward(cR.velocity.x,0, delta)
	cR.velocity.z = move_toward(cR.velocity.z,0, delta)


# TODO: determine if we should be grounded or inair
func _on_hurt_timer_timeout() -> void:
	transitioned.emit(self, "InairState")
