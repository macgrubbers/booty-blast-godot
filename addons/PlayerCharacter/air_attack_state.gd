extends State

class_name AirAttackState

var state_name : String = "AirAttack"

@onready var cR : CharacterBody3D
@onready var air_attack_area : Area3D = $"../../VisualRoot/AirAttackHitbox"

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	
	verifications()


func verifications():
	cR.godot_plush_skin.set_state("air_attack")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
	# for the attack area
	air_attack_area.set_monitoring(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass


func physics_update(delta : float):
	applies(delta)
	
	if cR.velocity.y > 0 and cR.has_cut_jump: gravity_apply(delta)
	else: cR.gravity_apply(delta)
	
	input_management()
	
	check_if_floor()
	
	move(delta)


func applies(delta : float):
	if !cR.is_on_floor(): 
		if cR.jump_cooldown > 0.0: cR.jump_cooldown -= delta
		if cR.coyote_jump_cooldown > 0.0: cR.coyote_jump_cooldown -= delta


func gravity_apply(delta : float):
	if cR.velocity.y >= 0.0: cR.velocity.y -= cR.jump_gravity / cR.jump_cut_multiplier * delta



func check_if_floor():
	if cR.is_on_floor():
		if cR.move_dir: transitioned.emit(self, cR.walk_or_run)
		else: transitioned.emit(self, "IdleState")

	if cR.is_on_wall():
		if cR.hit_wall_cut_velocity:
			cR.velocity.x = 0.0
			cR.velocity.z = 0.0


# Input that transitions states is not handled in this state
func input_management():
	pass

# TODO: add movement with attacking?
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


func _on_air_attack_area_entered(area: Area3D) -> void:
	if area is HealthComponent:
		print(cR)
		var dir_vector = cR.get_global_position().direction_to(area.get_global_position()).normalized()
		area.apply_knockback(dir_vector * 20 + Vector3(0,6,0),false)
		area.change_health(-1)


# Called when wave animation is complete
#	TODO: remove toggle to check states
func _on_animation_finished():
	if get_parent().curr_state is AirAttackState:
		air_attack_area.set_monitoring(false)
		transitioned.emit(self, "InairState")
