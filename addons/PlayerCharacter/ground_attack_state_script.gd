extends State

class_name GroundAttackState

var state_name : String = "GroundAttack"

@onready var cR : CharacterBody3D
@onready var ground_attack_area : Area3D = %GroundAttackHitbox

@onready var dash_dir:Vector2

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	
	verifications()


func verifications():
	#manage the appliements that need to be set at the start of the state
	cR.godot_plush_skin.set_state("gr_attack")
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.has_cut_jump: cR.has_cut_jump = false
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
	dash_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	if dash_dir.is_equal_approx(Vector2.ZERO):
		dash_dir = Vector2(sin(cR.visual_root.rotation.y), cos(cR.visual_root.rotation.y))
	
	cR.velocity.x = dash_dir.x * cR.dash_speed
	cR.velocity.z = dash_dir.y * cR.dash_speed

	
	# for the attack area
	ground_attack_area.set_monitoring(true)
	ground_attack_area.set_monitorable(true)


func physics_update(delta : float):
	cR.gravity_apply(delta)
	
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


# TODO: add movement with attacking?
func move(delta : float):
	pass


# Called when wave animation is complete
#	TODO: remove toggle to check states
func _on_animation_finished():
	if get_parent().curr_state is GroundAttackState:
		transitioned.emit(self, "IdleState")

func exit():
	ground_attack_area.set_monitoring(false)
	ground_attack_area.set_monitorable(false)
