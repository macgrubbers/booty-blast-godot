extends State

class_name ButtSlamState

var state_name : String = "ButtSlam"

var cR : CharacterBody3D
@onready var butt_slam_impact_hitbox : Area3D = $"../../ButtSlamAttackArea3D"

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	
	verifications()
	
func verifications():
	cR.godot_plush_skin.set_state("butt_slam")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
	# Stop horizontal velocity
	cR.jump_gravity
	cR.velocity.x = 0.0
	cR.velocity.z = 0.0
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	applies(delta)
	
	gravity_apply(delta)
	
	input_management()
	
	check_if_floor()
	
	#move(delta)
	
func applies(delta : float):
	if !cR.is_on_floor(): 
		if cR.jump_cooldown > 0.0: cR.jump_cooldown -= delta
		if cR.coyote_jump_cooldown > 0.0: cR.coyote_jump_cooldown -= delta
		
func gravity_apply(delta : float):
	cR.velocity.y -= cR.fall_gravity * cR.butt_slam_gravity_multiplier * delta
	# if cR.velocity.y >= 0.0: cR.velocity.y -= cR.jump_gravity / cR.jump_cut_multiplier * delta
		
func input_management():
	pass

# If landed, apply damage to area and transition states after a set time
func check_if_floor():
	if cR.is_on_floor():
		cR.squash_and_strech(0.3, 0.08)
		cR.particles_manager.display_particles(cR.land_particles, cR)
		
		toggle_butt_slam_hitbox()
		
		impact_audio_playing()
		
	if cR.is_on_wall():
		if cR.hit_wall_cut_velocity:
			cR.velocity.x = 0.0
			cR.velocity.z = 0.0
		
func move(delta : float):
	cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
		
	if cR.move_dir and !cR.is_on_floor():
		var in_air_move_speed_val : float
		var in_air_accel_val : float
		if cR.walk_or_run == "WalkState":
			in_air_move_speed_val = cR.in_air_move_speed[0].sample(cR.velocity.length())
			in_air_accel_val = cR.in_air_accel[0].sample(cR.velocity.length())
		elif cR.walk_or_run == "RunState":
			in_air_move_speed_val = cR.in_air_move_speed[1].sample(cR.velocity.length())
			in_air_accel_val = cR.in_air_accel[1].sample(cR.velocity.length())
		
		cR.velocity.x = lerp(cR.velocity.x, cR.move_dir.x * in_air_move_speed_val, in_air_accel_val * delta)
		cR.velocity.z = lerp(cR.velocity.z, cR.move_dir.y * in_air_move_speed_val, in_air_accel_val * delta)
		
func impact_audio_playing():
	#audio played when play char touch the ground after being in air
	#the volume is calculated based on the velocity pre ground hit, plus the fall gravity
	var floor_impact_percent : float = clamp(abs(cR.velocity.y), 0.0, cR.fall_gravity) / cR.fall_gravity
	cR.impact_audio.volume_db = linear_to_db(remap(floor_impact_percent, 0.0, 1.0, 0.5, 2.0))
	cR.impact_audio.play()

func toggle_butt_slam_hitbox():
	butt_slam_impact_hitbox.set_monitoring(true)
	await get_tree().create_timer(0.5).timeout
	butt_slam_impact_hitbox.set_monitoring(false)
	
	# TODO: idk what jump buff does, figured it's best to be here
	if cR.jump_buff_on: 
		cR.buffered_jump = true
		cR.jump_buff_on = false
		transitioned.emit(self, "JumpState")
	# Transition out of attack state
	if cR.move_dir: 
		transitioned.emit(self, cR.walk_or_run)
	else: 
		transitioned.emit(self, "IdleState")
	

func _on_butt_slam_attack_area_3d_area_entered(area : Area3D):
	if area is HealthComponent:
		var dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.apply_knockback(dir_vector * 50 + Vector3(0,12,0), false)
		area.change_health(-3)
