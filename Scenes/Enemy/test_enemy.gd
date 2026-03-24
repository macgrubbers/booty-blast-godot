extends CharacterBody3D

var perception_radius : float = 30

const SPEED = 8.0

var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var nav_timer = $NavigationTimer
@onready var health_component = $HealthComponent


func _ready() -> void:
	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		
	if nav_timer:
		nav_timer.connect("timeout", _on_nav_timer_timeout)
	
	if perception_component:
		perception_component.set_perception_radius(perception_radius)


func _physics_process(delta: float) -> void:
	# apply gravity
	if !is_on_floor():
		gravity_velocity += get_gravity() * delta
	elif is_on_floor() and gravity_velocity.length() > 0:
		gravity_velocity = Vector3.ZERO

	# Knockback and navigation
	var navigation_velocity = Vector3.ZERO
	if knockback_vector.length() > 0:
		knockback_vector = knockback_vector.move_toward(Vector3.ZERO, 50 * delta)
	
	if is_on_floor():
		# only navigate if not knocked back
		navigation_velocity = navigate()
	
	velocity = navigation_velocity + knockback_vector + gravity_velocity
	
	move_and_slide()


func navigate():
	if !nav_agent.is_navigation_finished():
		var next_path_position: Vector3 = nav_agent.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * SPEED

		# Update the nav timer
		if nav_timer.is_stopped():
			nav_timer.start()
	
		return new_velocity
	return Vector3.ZERO

# TODO: transition to grounded state maybe?
func knockback_apply(knockback_vec:Vector3, restart_gravity:bool):
	if restart_gravity:
		gravity_velocity = Vector3.ZERO
	knockback_vector = knockback_vec
	print("knockback enemy")


# Call on enemy death
func kill():
	queue_free()

# On navigation timer timeout
func _on_nav_timer_timeout()->void:
	if perception_component.player_ref:
		nav_agent.set_target_position(perception_component.player_ref.global_position)


# Start tracking the player by starting the timer
#	TODO: Timer must cycle start once before player is tracked, change this
func start_tracking_player()->void:
	if nav_agent.is_navigation_finished():
		nav_agent.set_target_position(perception_component.player_ref.global_position)



func _on_attack_area_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Player"):
		area.change_health(-1)
		var k_scale = 10
		var knockback_vec = global_position.direction_to(area.get_global_position()).normalized() * k_scale \
				 + Vector3(0,k_scale,0)
		area.apply_knockback(knockback_vec, true)
	
func _on_enemy_dead():
	kill()
