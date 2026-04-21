extends State

class_name Enemy_HurtState

var state_name : String = "Hurt"

var cR : CharacterBody3D
@onready var hurt_timer : Timer = $HurtTimer


func enter(char_ref : CharacterBody3D):
	print("entering hurt state!")
	#pass play char reference
	cR = char_ref
	hurt_timer.start()

	verifications()
	
func verifications():
	pass
	
	
func physics_update(delta : float):
	cR.gravity_apply(delta)
	# dampen
	cR.velocity.x = move_toward(cR.velocity.x,0, delta)
	cR.velocity.z = move_toward(cR.velocity.z,0, delta)


# TODO: determine if we should be grounded or inair
#func _on_hurt_timer_timeout() -> void:
	#print("leaving hurt state!")
	#transitioned.emit(self, "Enemy_IdleState")
