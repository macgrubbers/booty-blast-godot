extends State

class_name ButtSlamState

var state_name : String = "ButtSlam"

var cR : CharacterBody3D
@onready var floor_raycast: RayCast3D = %FloorRaycast
@onready var butt_slam_land_hitbox : Area3D = $"../../ButtSlamLandHitbox"
@onready var falling_hitbox : Area3D = $"../../FallingHitbox"
@onready var land_timer: Timer = $Timer
@export var attack_damage:int = 3
@export var attack_level:int = 1
@export var knockback_magnitude:float = 15
@export var extra_knockback_vec:Vector3 = Vector3(0,12,0)

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	verifications()
	

func verifications():
	land_timer.connect("timeout", _on_land_timer_timeout)
	falling_hitbox.set_monitoring(true)
	cR.godot_plush_skin.set_state("butt_slam")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false

	# Stop horizontal velocity
	#cR.jump_gravity
	cR.velocity.x = 0.0
	cR.velocity.y = 0.0
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
		# first time landing
		if falling_hitbox.monitoring == true:
			cR.cam_holder.add_trauma(.55)
			land_timer.start()
			falling_hitbox.set_monitoring(false)
			butt_slam_land_hitbox.set_monitoring(true)
			just_landed.emit()

		cR.squash_and_strech(0.3, 0.08)
		cR.particles_manager.display_particles(cR.land_particles, cR)
		
		impact_audio_playing()
	else:
		prev_in_air_velocity = cR.velocity

	#if cR.is_on_wall():
		#if cR.hit_wall_cut_velocity:
			#cR.velocity.x = 0.0
			#cR.velocity.z = 0.0

# audio played when play char touch the ground after being in air
# the volume is calculated based on the velocity pre ground hit, plus the fall gravity
func impact_audio_playing():
	var floor_impact_percent : float = clamp(abs(cR.velocity.y), 0.0, cR.fall_gravity) / cR.fall_gravity
	cR.impact_audio.volume_db = linear_to_db(remap(floor_impact_percent, 0.0, 1.0, 0.5, 2.0))
	cR.impact_audio.play()


func _on_land_timer_timeout():
	if cR.move_dir: 
		transitioned.emit(self, cR.walk_or_run)
	else: 
		transitioned.emit(self, "IdleState")

# Signaled when falling hitbox is entered
func _on_butt_slam_falling_hitbox_entered(area : Area3D):
	if area is HealthComponent:
		var dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.attack(3,attack_level, cR, Vector3(0,-50,0))
		
		# apply knockback up to player if it's an enemy
		if !area.get_owner().is_in_group("Destructables"):
			cR.velocity.y = 0
			cR.health_component.apply_knockback(Vector3(0,12,0),true)
		
		# Refresh jump as if landed
		cR.floor_snap_length = 1.0
		if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
		if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
		if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
		if cR.has_cut_jump: cR.has_cut_jump = false
		
		falling_hitbox.set_monitoring(false)
		transitioned.emit(self, "InairState")


# Signaled when landing hitbox is entered
func _on_butt_slam_landing_hitbox_entered(area : Area3D):
	if area is HealthComponent:
		var knockback_dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.attack(attack_damage, 
					attack_level, 
					cR,
					(knockback_dir_vector * knockback_magnitude) + extra_knockback_vec)


func exit():
	print("exit state")
	falling_hitbox.set_monitoring(false)
	butt_slam_land_hitbox.set_monitoring(false)
	land_timer.stop()
	print(land_timer.is_stopped())
