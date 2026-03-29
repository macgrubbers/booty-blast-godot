extends State

class_name GroundAttackState

var state_name : String = "GroundAttack"

@onready var cR : CharacterBody3D
@onready var ground_attack_area : Area3D = %GroundAttackHitbox

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
	
	# for the attack area
	ground_attack_area.set_monitoring(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass


func physics_update(delta : float):
	cR.gravity_apply(delta)
	
	input_management()
	
	#check_if_floor()
	
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

# TODO: add movement with attacking?
func move(delta : float):
	cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	
	if cR.move_dir and cR.is_on_floor():
		#apply smooth move
		cR.velocity.x = lerp(cR.velocity.x, cR.move_dir.x * cR.move_speed, cR.move_accel * delta)
		cR.velocity.z = lerp(cR.velocity.z, cR.move_dir.y * cR.move_speed, cR.move_accel * delta)



func _on_ground_attack_area_3d_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		print(cR)
		var dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.apply_knockback(dir_vector * 20 + Vector3(0,6,0),false)
		area.change_health(-1)



func _on_animation_finished():
	ground_attack_area.set_monitoring(false)
	transitioned.emit(self, "IdleState")
