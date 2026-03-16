extends State

class_name GroundAttackState

var state_name : String = "GroundAttack"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	print("tryna enter state")
	#pass play char reference
	cR = char_ref
	
	verifications()


func verifications():
	#manage the appliements that need to be set at the start of the state
	cR.godot_plush_skin.set_state("wave")
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.has_cut_jump: cR.has_cut_jump = false
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass


func physics_update(delta : float):
	check_if_floor()
	
	cR.gravity_apply(delta)
	
	input_management()
	
	move(delta)
	
func check_if_floor():
	#manage the appliements and state transitions that needs to be sets/checked/performed
	#every time the play char pass through one of the following : floor-inair-onwall
	if !cR.is_on_floor() and !cR.is_on_wall():
		transitioned.emit(self, "InairState")
	if cR.is_on_floor():
		if cR.jump_buff_on: 
			cR.buffered_jump = true
			cR.jump_buff_on = false
			transitioned.emit(self, "JumpState")

# Input that transitions states is not handled in this state
func input_management():
	pass


# TODO: Add movement on this state later
func move(delta : float):
	pass
