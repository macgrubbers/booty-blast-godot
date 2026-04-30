class_name DashState extends State

var state_name : String = "Dash"

var dash_dir:Vector2
var cR : CharacterBody3D

@onready var timer : Timer = $DashTimer

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	dash_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	if dash_dir.is_equal_approx(Vector2.ZERO):
		dash_dir = Vector2(sin(cR.visual_root.rotation.y), cos(cR.visual_root.rotation.y))
	
	cR.velocity.y = 0
	verifications()
	
func verifications():
	cR.godot_plush_skin.set_state("run")
	timer.set_wait_time(cR.dash_duration)
	timer.connect("timeout", _on_timer_timeout)
	timer.start()
	
	#cR.move_speed = cR.dash_speed
	#cR.move_accel = cR.run_accel
	#cR.move_deccel = cR.run_deccel
	
	# Copied over from run state
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.has_cut_jump: cR.has_cut_jump = false
	if !cR.movement_dust.emitting: cR.movement_dust.emitting = true
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	check_if_floor()
	
	#cR.gravity_apply(delta)
	
	input_management()
	
	move(delta)
	
func check_if_floor():
	if cR.is_on_floor():
		if cR.jump_buff_on:
			cR.buffered_jump = true
			cR.jump_buff_on = false
			transitioned.emit(self, "JumpState")
			
func input_management():
	pass
		
		
func move(delta : float):
	#cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	cR.move_dir.x
	cR.move_dir.y
	cR.velocity.x = lerp(cR.velocity.x, dash_dir.x * cR.dash_speed, cR.dash_accel * delta)
	cR.velocity.z = lerp(cR.velocity.z, dash_dir.y * cR.dash_speed, cR.dash_accel * delta)


func _on_timer_timeout():
	if !cR.is_on_floor():
		transitioned.emit(self, "InairState")
			
	if cR.is_on_floor():
		if cR.jump_buff_on:
			cR.buffered_jump = true
			cR.jump_buff_on = false
			transitioned.emit(self, "JumpState")
		transitioned.emit(self, cR.walk_or_run)
