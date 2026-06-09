class_name DashState extends State

var state_name : String = "Dash"

var dash_dir:Vector2
var cR : CharacterBody3D

@onready var timer : Timer = $DashDurationTimer

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	dash_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	if dash_dir.is_equal_approx(Vector2.ZERO):
		dash_dir = Vector2(sin(cR.visual_root.rotation.y), cos(cR.visual_root.rotation.y))
	
	verifications()
	
func verifications():
	cR.velocity.y = 0
	cR.just_dashed()
	cR.godot_plush_skin.set_state("run")
	timer.set_wait_time(cR.dash_duration)
	timer.connect("timeout", _on_timer_timeout)
	timer.start()
	
	cR.cam_holder.lock_camera_vertical = false
	
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
