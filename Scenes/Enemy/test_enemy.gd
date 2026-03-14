extends CharacterBody3D

var perception_radius : float = 30

const SPEED = 8.0

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var nav_timer = $NavigationTimer


func _ready() -> void:
	if nav_timer:
		nav_timer.connect("timeout", _on_nav_timer_timeout)
	
	if perception_component:
		perception_component.set_perception_radius(perception_radius)


func _physics_process(delta: float) -> void:
	
	if !nav_agent.is_navigation_finished():
		var next_path_position: Vector3 = nav_agent.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * SPEED * delta
		global_position = global_position.move_toward(global_position + new_velocity, SPEED * delta)
		
		# Update the nav timer
		if nav_timer.is_stopped():
			nav_timer.start()

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
		print("player!")
		area.change_health(-1)
		var k_scale = 10
		var knockback_vec = global_position.direction_to(area.get_global_position()).normalized() * k_scale \
				 + Vector3(0,k_scale,0)
		area.apply_knockback(knockback_vec, true)
	
