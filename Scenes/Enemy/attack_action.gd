@tool
class_name Melee_AttackAction extends ActionLeaf

var attack_point:Vector3
var animation_finished:bool = false

@onready var visuals = $"../../../../../../../../../VisualRoot/LilGooberVisuals"


func before_run(actor: Node, blackboard: Blackboard) -> void:
	visuals.connect("attack_finished", _on_animation_finished)
	visuals.play_attack()
	attack_point = blackboard.get_value("last_seen_player_pos")
	actor.get_velocity()
	
	blackboard.set_value("is_attacking", true)


func tick(actor: Node, blackboard: Blackboard) -> int:
	if animation_finished:
		return SUCCESS
		
	actor.gravity_apply()
	
	# Navigation
	var navigation_velocity = Vector3.ZERO
	# only navigate if not knocked back
	navigation_velocity = navigate(actor)
	if navigation_velocity:
		if actor.is_on_floor():
			var movement_acceleration = 0.4
			actor.velocity = actor.velocity.move_toward(navigation_velocity, movement_acceleration)
	return RUNNING


func navigate(actor: Node):
	if !actor.nav_agent.is_navigation_finished():
		var next_path_position: Vector3 = actor.nav_agent.get_next_path_position()
		var new_velocity: Vector3 = actor.global_position.direction_to(next_path_position) * actor.SPEED
		
		# rotate model for looks #TODO: move somewhere else? idk
		actor.visual_root.look_at(next_path_position, Vector3.UP)
		actor.visual_root.rotation.x = 0
		actor.visual_root.rotation.z = 0
		
		return new_velocity

func _on_animation_finished():
	animation_finished = true


func after_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value("in_attack_range", false) # Reset in attack range
	blackboard.set_value("just_attacked", true)
	blackboard.set_value("is_attacking", false)
