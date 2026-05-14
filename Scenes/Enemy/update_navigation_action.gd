@tool
class_name Melee_UpdateNavigationAction extends ActionLeaf

@onready var nav_agent:NavigationAgent3D = $"../../../../../../../NavigationAgent3D"

func tick(actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("see_player"):
		if !blackboard.get_value("in_attack_range"):
			var player_pos = blackboard.get_value("last_seen_player_pos")
			nav_agent.set_target_position(player_pos)
			blackboard.set_value("is_navigation_finished", false)
		else:
			nav_agent.set_target_position(actor.global_position)
	else:
		# Do task maybe, or maybe just do nothing
		pass
		
	return SUCCESS
