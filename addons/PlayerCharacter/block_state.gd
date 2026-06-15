class_name BlockState extends State

var state_name : String = "Block"

@onready var block_timer: Timer = $Timer
@onready var shield: MeshInstance3D = $"../../VisualRoot/Shield"
@onready var health_component: HealthComponent
var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	
	verifications()
	
func verifications():
	shield.visible = true
	block_timer.connect("timeout", _on_block_timer_timeout)
	block_timer.start()
	health_component = cR.health_component
	health_component.block_state = true
	health_component.connect("attack_unsuccessful", block_attack)
	health_component.can_be_hurt = false
	
	cR.godot_plush_skin.set_state("tpose lmao")
	cR.move_speed = cR.walk_speed
	cR.move_accel = cR.walk_accel
	cR.move_deccel = cR.walk_deccel
	
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.has_cut_jump: cR.has_cut_jump = false
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	#check_if_floor()
	
	cR.gravity_apply(delta)
	
	#input_management()
	
	move(delta)
	
#func check_if_floor():
	#if !cR.is_on_floor(): # and !cR.is_on_wall():
		#if cR.velocity.y < 0.0:
			#transitioned.emit(self, "InairState")

	#if cR.is_on_floor():
		#if cR.jump_buff_on:
			##apply jump buffering
			#cR.buffered_jump = true
			#cR.jump_buff_on = false
			#transitioned.emit(self, "JumpState")
			
#func input_management():
	#if Input.is_action_pressed(cR.jumpAction) if cR.auto_jump else Input.is_action_just_pressed(cR.jumpAction) :
		#transitioned.emit(self, "JumpState")
		#
	#if Input.is_action_just_pressed(cR.runAction):
		#cR.walk_or_run = "RunState"
		#transitioned.emit(self, "RunState")
		#
	#if Input.is_action_just_pressed("x"):
		#if !cR.godot_plush_skin.ragdoll:
			#transitioned.emit(self, "RagdollState")
			#
	#if Input.is_action_just_pressed("lmb"):
		#transitioned.emit(self, "GroundAttackState")
#
	#if Input.is_action_just_pressed("v"):
		#if !cR.godot_plush_skin.ragdoll and cR.can_dash:
			#transitioned.emit(self, "DashState")
		
func move(delta : float):
	cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	
	if cR.move_dir and cR.is_on_floor():
		#apply smooth move
		cR.velocity.x = lerp(cR.velocity.x, cR.move_dir.x * (cR.move_speed/3), cR.move_accel * delta)
		cR.velocity.z = lerp(cR.velocity.z, cR.move_dir.y * (cR.move_speed/3), cR.move_accel * delta)

func _on_block_timer_timeout():
	if !cR.is_on_floor():
		transitioned.emit(self, "InairState")
		return
		
	if Input.is_action_just_pressed(cR.runAction):
		if cR.walk_or_run == "WalkState": cR.walk_or_run = "RunState"
		elif cR.walk_or_run == "RunState": cR.walk_or_run = "WalkState"
		transitioned.emit(self, cR.walk_or_run)
		return

	if Input.is_action_pressed(cR.jumpAction) if cR.auto_jump else Input.is_action_just_pressed(cR.jumpAction) :
		transitioned.emit(self, "JumpState")
		return
	
	transitioned.emit(self, "IdleState")

func exit():
	health_component.block_state = false
	health_component.disconnect("attack_unsuccessful", block_attack)
	health_component.can_be_hurt = true
	shield.visible = false

# Handle block behvavior
func block_attack(attacker:Node3D):
	if attacker.is_in_group("Projectiles"):
		attacker.return_to_sender()
		return
		
	elif attacker.is_in_group("Structures"):
		return
	
	else:
		var knockback_amount = Vector3(randf(),randf(),randf()) * 10
		attacker.health_component.attack(3, 3, owner)
		return
