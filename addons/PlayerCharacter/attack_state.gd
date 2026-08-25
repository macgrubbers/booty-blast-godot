class_name AttackState extends State

var state_name : String = "Attack"

@onready var cR : CharacterBody3D
@onready var attack_area : Area3D = %GroundAttackHitbox
@onready var forward_raycast : RayCast3D = $"../../Raycasts/InteractRaycast"
@onready var applied_rotation_timer : Timer = $"../../HealthComponent/AppliedRotationTimer"
@onready var health_component : HealthComponent = $"../../HealthComponent"



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
	cR.velocity.y = 0
	cR.velocity.z = dash_dir.y * cR.dash_speed

	
	# for the attack area
	attack_area.set_monitoring(true)
	attack_area.set_monitorable(true)


func physics_update(delta : float):
	cR.gravity_apply(delta)
	
	

	if cR.can_wall_jump:
		check_if_wall_jump()

# Check if we should wall jump 
# TODO: use the hitbox to detect instead of a raycast?
func check_if_wall_jump():
	var collider = forward_raycast.get_collider()
	if collider and applied_rotation_timer.is_stopped():
		wall_jump()

# Wall jump off of wall or enemy
# 	TODO: reflection angle is just y-rotation flipped 180
func wall_jump():
	#cR.can_wall_jump = false
	var model_rotation = cR.visual_root.rotation.y
	cR.velocity = Vector3.ZERO # TODO: Conserve momentum somehow?
	health_component.apply_knockback(-Vector3(sin(model_rotation), -1.5, cos(model_rotation)) * 10,false)
	cR.visual_root.rotation.y += PI
	applied_rotation_timer.start()
	transitioned.emit(self, "InairState")

# Called when wave animation is complete
#	TODO: remove toggle to check states
func _on_animation_finished():
	transitioned.emit(self, "IdleState")

func exit():
	attack_area.set_monitoring(false)
	attack_area.set_monitorable(false)
