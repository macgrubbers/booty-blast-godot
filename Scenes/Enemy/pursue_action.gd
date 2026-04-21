@tool
extends ActionLeaf

var state_name : String = "Pursue"

var movement_acceleration : float = 0.4
var movement_velocity : Vector3 = Vector3.ZERO

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply(blackboard.get_value("delta"))
	
	# Navigation
	var navigation_velocity = Vector3.ZERO
	if actor.is_on_floor():
		# only navigate if not knocked back
		navigation_velocity = navigate(actor)
		if navigation_velocity:
			actor.velocity = actor.velocity.move_toward(navigation_velocity, movement_acceleration)
	
	
	return SUCCESS
	


func navigate(actor):
	if !actor.nav_agent.is_navigation_finished():
		var next_path_position: Vector3 = actor.nav_agent.get_next_path_position()
		var new_velocity: Vector3 = actor.global_position.direction_to(next_path_position) * actor.SPEED
		
		# rotate model for looks #TODO: move somewhere else? idk
		actor.visual_root.look_at(next_path_position, Vector3.UP)
		actor.visual_root.rotation.x = 0
		actor.visual_root.rotation.z = 0
		
		return new_velocity
	return null
