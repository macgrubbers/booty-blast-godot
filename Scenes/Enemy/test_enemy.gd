extends CharacterBody3D

var perception_radius : float = 30

const SPEED = 8.0

var movement_acceleration : float = 0.4
var movement_velocity : Vector3 = Vector3.ZERO
var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var nav_timer = $NavigationTimer
@onready var health_component = $HealthComponent


func _ready() -> void:
	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)
		
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

	# Knockback
	if knockback_vector.length() > 0:
		knockback_vector = knockback_vector.move_toward(Vector3.ZERO, 30 * delta)
	
	# Navigation
	var navigation_velocity = Vector3.ZERO
	if is_on_floor() and health_component.is_alive:
		# only navigate if not knocked back
		navigation_velocity = navigate()
		movement_velocity = movement_velocity.move_toward(navigation_velocity, movement_acceleration)
	else:
		movement_velocity = Vector3.ZERO
	
	velocity = movement_velocity + knockback_vector + gravity_velocity
	
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
	if !health_component.is_alive:
		return
	
	if area.get_parent().is_in_group("Player"):
		var player_pos = area.get_parent().get_global_position()
		area.change_health(-1,global_position)
		var k_scale = 10
		var knockback_vec = global_position.direction_to(player_pos).normalized() * k_scale \
				 + Vector3(0,k_scale,0)
		area.apply_knockback(knockback_vec, true)
	
func _on_enemy_dead():
	health_component.set_monitoring(false)
	health_component.set_monitorable(false)
	health_component.start_kill_timer()

func _on_kill_timer_timeout():
	queue_free()
