extends State

class_name InairState

var state_name : String = "Inair"

@onready var state_machine = $".."
@onready var falling_hitbox:BaseHitbox = $"../../FallingHitbox"
@onready var ledge_raycast1: RayCast3D = $"../../Raycasts/LedgeGrabRaycast1"
@onready var ledge_raycast2 : RayCast3D = $"../../Raycasts/LedgeGrabRaycast2"
@onready var ledge_shapecast :ShapeCast3D = $"../../Raycasts/LedgeGrabRaycast3/LedgeGrabShapecast"
@onready var cam = $"../../OrbitView"

var cR : CharacterBody3D
var health_component : HealthComponent

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	health_component = cR.health_component
	
	verifications()
	
func verifications():
	ledge_raycast1.enabled = true
	ledge_raycast2.enabled = true
	falling_hitbox.monitoring = true
	falling_hitbox.connect("attack_successful", _on_falling_attack_successful)
	cR.godot_plush_skin.set_state("fall")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
	# Camera locking
	await get_tree().physics_frame
	if state_machine.prev_state is JumpState and cR.nb_jumps_in_air_allowed > 0:
		cR.cam_holder.lock_camera_vertical = true
	else:
		cR.cam_holder.lock_camera_vertical = false
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	applies(delta)
	
	if cR.velocity.y > 0 and cR.has_cut_jump: gravity_apply(delta)
	else: cR.gravity_apply(delta)
	
	input_management()
	
	check_if_floor()
	
	check_if_ledge()
	
	move(delta)
	
func applies(delta : float):
	if !cR.is_on_floor(): 
		if cR.jump_cooldown > 0.0: cR.jump_cooldown -= delta
		if cR.coyote_jump_cooldown > 0.0: cR.coyote_jump_cooldown -= delta

func check_if_ledge():
	if ledge_raycast1.is_colliding() and !ledge_raycast2.is_colliding():
		# Check shapecast to see if we can fit above, helps with edges and corners
		ledge_shapecast.force_shapecast_update()
		if !ledge_shapecast.is_colliding():
			transitioned.emit(self, "LedgeGrabState")

func gravity_apply(delta : float):
	if cR.velocity.y >= 0.0: cR.velocity.y -= cR.jump_gravity / cR.jump_cut_multiplier * delta
		
func input_management():
	if Input.is_action_just_pressed(cR.jumpAction) :
		#check if can jump buffer
		if cR.floor_check.is_colliding() and cR.last_frame_position.y > cR.position.y and cR.nb_jumps_in_air_allowed <= 0: cR.jump_buff_on = true
		#check if can coyote jump
		if cR.was_on_floor and cR.coyote_jump_cooldown > 0.0 and cR.last_frame_position.y > cR.position.y:
			cR.coyote_jump_on = true
			transitioned.emit(self, "JumpState")
		# jump if we have the jumps for it
		if cR.nb_jumps_in_air_allowed > 0:
			transitioned.emit(self, "JumpState")
		
	if Input.is_action_just_pressed("x"):
		if !cR.godot_plush_skin.ragdoll and !cR.ragdoll_on_floor_only:
			transitioned.emit(self, "RagdollState")
			
	if Input.is_action_just_pressed("butt_slam"):
		transitioned.emit(self, "ButtSlamState")
		
	if Input.is_action_just_pressed("lmb"):
		transitioned.emit(self, "AirAttackState")
		
	if Input.is_action_just_pressed("v"):
		if !cR.godot_plush_skin.ragdoll and cR.can_dash:
			transitioned.emit(self, "DashState")
			
	if Input.is_action_just_pressed("rmb"):
		if !cR.godot_plush_skin.ragdoll:
			transitioned.emit(self, "BlockState")
			
	if Input.is_action_just_pressed("x"):
		if !cR.godot_plush_skin.ragdoll:
			transitioned.emit(self, "RagdollState")
		
func check_if_floor():
	if cR.is_on_floor():
		if cR.jump_buff_on: 
			cR.buffered_jump = true
			cR.jump_buff_on = false
			transitioned.emit(self, "JumpState")
			
		cR.squash_and_strech(0.8, 0.08)
		cR.particles_manager.display_particles(cR.land_particles, cR)
		
		impact_audio_playing()
		
		just_landed.emit()
		if cR.move_dir: transitioned.emit(self, cR.walk_or_run)
		else: transitioned.emit(self, "IdleState")
	else:
		prev_in_air_velocity = cR.velocity
		
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
		print(abs(cR.velocity.x) + abs(cR.velocity.z))
		
func impact_audio_playing():
	#audio played when play char touch the ground after being in air
	#the volume is calculated based on the velocity pre ground hit, plus the fall gravity
	var floor_impact_percent : float = clamp(abs(cR.velocity.y), 0.0, cR.fall_gravity) / cR.fall_gravity
	cR.impact_audio.volume_db = linear_to_db(remap(floor_impact_percent, 0.0, 1.0, 0.5, 2.0))
	cR.impact_audio.play()

func exit():
	ledge_raycast1.enabled = false
	ledge_raycast2.enabled = false
	falling_hitbox.monitoring = false
	falling_hitbox.disconnect("attack_successful", _on_falling_attack_successful)


func _on_falling_attack_successful():
	cR.velocity.y = 0
	health_component.apply_knockback(Vector3(0,10,0),false)
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.has_cut_jump: cR.has_cut_jump = false
