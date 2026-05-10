extends State

class_name ButtSlamState

var state_name : String = "ButtSlam"

var cR : CharacterBody3D
@onready var butt_slam_land_hitbox : Area3D = $"../../ButtSlamLandHitbox"
@onready var butt_slam_falling_hitbox : Area3D = $"../../ButtSlamFallingHitbox"

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	verifications()
	butt_slam_falling_hitbox.set_monitoring(true)
	
func verifications():
	cR.godot_plush_skin.set_state("butt_slam")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
	# Stop horizontal velocity
	cR.jump_gravity
	cR.velocity.x = 0.0
	cR.velocity.z = 0.0
	
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

# Checks if the player is on the floor
# If true:
#	Squashes player model
#	Toggles falling hitbox off
#	Toggles land hitbox on for a set time and transitions states
func check_if_floor():
	if cR.is_on_floor():
		butt_slam_falling_hitbox.set_monitoring(false)
		cR.squash_and_strech(0.3, 0.08)
		cR.particles_manager.display_particles(cR.land_particles, cR)
		
		toggle_butt_slam_land_hitbox()
		
		impact_audio_playing()
		
	if cR.is_on_wall():
		if cR.hit_wall_cut_velocity:
			cR.velocity.x = 0.0
			cR.velocity.z = 0.0

# audio played when play char touch the ground after being in air
# the volume is calculated based on the velocity pre ground hit, plus the fall gravity
func impact_audio_playing():
	var floor_impact_percent : float = clamp(abs(cR.velocity.y), 0.0, cR.fall_gravity) / cR.fall_gravity
	cR.impact_audio.volume_db = linear_to_db(remap(floor_impact_percent, 0.0, 1.0, 0.5, 2.0))
	cR.impact_audio.play()

# When landed, toggle the hitbox on for a start a timer
# When the timer ends, hitbox is toggled off and state is transitioned
func toggle_butt_slam_land_hitbox():
	butt_slam_land_hitbox.set_monitoring(true)
	await get_tree().create_timer(0.5).timeout
	butt_slam_land_hitbox.set_monitoring(false)
	
	# Transition out of attack state
	if cR.move_dir: 
		transitioned.emit(self, cR.walk_or_run)
	else: 
		transitioned.emit(self, "IdleState")

# Signaled when falling hitbox is entered
func _on_butt_slam_falling_hitbox_entered(area : Area3D):
	if area is HealthComponent:
		print("butt slam hit!")
		var dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.apply_knockback(Vector3(0,-50,0), false)
		area.change_health(-3)
		
		# apply knockback up to player
		cR.velocity.y = 0
		cR.health_component.apply_knockback(Vector3(0,12,0),true)
		
		# Refresh jump as if landed
		cR.floor_snap_length = 1.0
		if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
		if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
		if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
		if cR.has_cut_jump: cR.has_cut_jump = false
		
		butt_slam_falling_hitbox.set_monitoring(false)
		print("butt slam bounce!")
		transitioned.emit(self, "InairState")


# Signaled when landing hitbox is entered
func _on_butt_slam_landing_hitbox_entered(area : Area3D):
	if area is HealthComponent:
		var dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.apply_knockback(dir_vector * 15 + Vector3(0,12,0), false)
		area.change_health(-3)
