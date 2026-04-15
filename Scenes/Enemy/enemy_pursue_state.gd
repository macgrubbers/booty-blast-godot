extends State

class_name Enemy_PursueState

var state_name : String = "Pursue"

var movement_acceleration : float = 0.4
var movement_velocity : Vector3 = Vector3.ZERO



var cR : CharacterBody3D
var health_component : HealthComponent
var nav_timer : Timer
var nav_agent : NavigationAgent3D
var perception_component
var char_ref : CharacterBody3D
@onready var visual_root : Node3D = $"../../VisualRoot"



func enter(char_ref : CharacterBody3D):
	# 	Connect components
	cR = char_ref
	health_component = cR.health_component
	perception_component = cR.perception_component
	perception_component.connect("player_lost",on_player_lost)
	perception_component.connect("navigation_finished", on_navigation_finished)
	nav_timer = perception_component.nav_timer
	nav_timer.connect("timeout", _on_nav_timer_timeout)
	nav_agent = cR.nav_agent
	char_ref = perception_component.player_ref
	
	verifications()
	
func verifications():
	pass
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	check_if_floor()
	cR.gravity_apply(delta)
	
	# Navigation
	var navigation_velocity = Vector3.ZERO
	if cR.is_on_floor() and health_component.is_alive:
		# only navigate if not knocked back
		navigation_velocity = navigate()
		if navigation_velocity:
			cR.velocity = cR.velocity.move_toward(navigation_velocity, movement_acceleration)
	
	
func check_if_floor():
	if !cR.is_on_floor() and !cR.is_on_wall():
		if cR.velocity.y < 0.0:
			pass
			#transitioned.emit(self, "InairState")


func navigate():
	if !nav_agent.is_navigation_finished():
		var next_path_position: Vector3 = nav_agent.get_next_path_position()
		var new_velocity: Vector3 = cR.global_position.direction_to(next_path_position) * cR.SPEED
		
		# Update the nav timer
		if nav_timer.is_stopped():
			nav_timer.start()
		
		# rotate model for looks #TODO: move somewhere else? idk
		visual_root.look_at(next_path_position, Vector3.UP)
		visual_root.rotation.x = 0
		visual_root.rotation.z = 0
		
		return new_velocity
	return null


# On navigation timer timeout
func _on_nav_timer_timeout()->void:
	if perception_component.player_ref:
		nav_agent.set_target_position(perception_component.player_ref.global_position)

func on_player_lost():
	print("player lost!")
	if nav_agent.is_navigation_finished():
		
		transitioned.emit(self, "Enemy_IdleState")
	

func on_navigation_finished():
	print("navigation finished!")
	transitioned.emit(self, "Enemy_IdleState")
