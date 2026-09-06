class_name AttackState extends State

var state_name : String = "Attack"

@onready var cR : CharacterBody3D
@onready var attack_area : Area3D = %HipCheckHitbox
@onready var attack_shapecast:ShapeCast3D = %HipCheckHitbox/ShapeCast3D
@onready var forward_raycast : RayCast3D = $"../../Raycasts/InteractRaycast"
@onready var applied_rotation_timer : Timer = $"../../HealthComponent/AppliedRotationTimer"
@onready var health_component : HealthComponent = %HealthComponent

@onready var dash_dir:Vector2


func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	
	verifications()


func verifications():
	cR.godot_plush_skin.set_state("gr_attack")
	
	# Determine attack direciton
	dash_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	if dash_dir.is_equal_approx(Vector2.ZERO):
		dash_dir = Vector2(sin(cR.visual_root.rotation.y), cos(cR.visual_root.rotation.y))
	
	# Set dash velocity
	cR.velocity.x = dash_dir.x * cR.dash_speed
	cR.velocity.y = 0
	cR.velocity.z = dash_dir.y * cR.dash_speed

	# Attack area signals and hitbox
	attack_area.set_monitoring(true)
	attack_area.connect("area_entered", _on_area_entered)
	attack_area.connect("body_entered", _on_body_entered)
	cR.godot_plush_skin.wave_done.connect(exit)
	
	# Check hitbox for initial overlaps
	check_hitbox()


# Manually check the hitboxes for overlaps
# Used for initial node transition
func check_hitbox():
	var collided = false
	
	# Check for overlapping areas on start
	# TODO: maybe a signal is better here idk
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	if overlapping_bodies:
		collided = true
		_on_body_entered(overlapping_bodies[0])
		
	var overlapping_areas = attack_area.get_overlapping_areas()
	if overlapping_areas:
		collided = true
		_on_area_entered(overlapping_areas[0])
		
	#if collided:
		#attack_area.set_monitoring(false)


# Update gravity
func physics_update(delta : float):
	cR.gravity_apply(delta)


func _on_area_entered(area:Area3D):
	# For knockback, may not be used
	var model_rotation = cR.visual_root.rotation.y 
	var knockback_dir = Vector3(sin(model_rotation), 0, cos(model_rotation))
	var attack_successful = false
	# Check shapecast
	attack_shapecast.force_shapecast_update()
	var total_collisions = attack_shapecast.get_collision_count()
	# TODO: could this ever be more than 1?
	for n in range(total_collisions):
		var collider:Object = attack_shapecast.get_collider(n)
		if collider is HealthComponent:
			var knockback_mag = 10
			# TODO: Maybe knockback dir is different each time
			collider.attack(3,1, owner, knockback_dir * knockback_mag)
			attack_successful = true
	
	# If we hit something successfully, knockback ourselves!
	if attack_successful:
		var player_knockback_mag = 7
		var extra_vertical_konockback = Vector3(0,13,0)
		health_component.apply_knockback(-knockback_dir * player_knockback_mag + extra_vertical_konockback,
		true, true)
		transitioned.emit(self, "InairState")


func _on_body_entered(body:Node3D):
	var model_rotation = cR.visual_root.rotation.y 
	var knockback_dir = Vector3(sin(model_rotation), 0, cos(model_rotation))
	var player_knockback_mag = 15
	var extra_vertical_konockback = Vector3(0,15,0)
	health_component.apply_knockback(-knockback_dir * player_knockback_mag + extra_vertical_konockback,
	false, true)
	cR.visual_root.rotation.y *= -1
	var inactionable_status:InactionableStatusEffect = InactionableStatusEffect.new()
	inactionable_status.duration = 0.3
	health_component.apply_status_effect(inactionable_status)
	transitioned.emit(self, "InairState")


# Wall jump off of wall or enemy
# 	TODO: reflection angle is just y-rotation flipped 180
#func wall_jump():
	##cR.can_wall_jump = false
	#var model_rotation = cR.visual_root.rotation.y
	#cR.velocity = Vector3.ZERO # TODO: Conserve momentum somehow?
	#health_component.apply_knockback(-Vector3(sin(model_rotation), -1.5, cos(model_rotation)) * 10,false)
	#cR.visual_root.rotation.y += PI
	#applied_rotation_timer.start()
	#transitioned.emit(self, "InairState")


# Called when wave animation is complete
#	TODO: determine if it should be a ground or air state next
func _on_animation_finished():
	transitioned.emit(self, "IdleState")

# Exit state
func exit():
	#check_if_wall_jump()
	attack_area.set_monitoring(false)
	attack_area.disconnect("area_entered", _on_area_entered)
	attack_area.disconnect("body_entered", _on_body_entered)
	cR.godot_plush_skin.wave_done.disconnect(exit)
	#attack_area.disconnect("attack_successful", check_if_wall_jump)
