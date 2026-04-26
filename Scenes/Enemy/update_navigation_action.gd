@tool
class_name Melee_UpdateNavigationAction extends ActionLeaf

@onready var nav_agent:NavigationAgent3D = $"../../../../../../../NavigationAgent3D"

func tick(actor: Node, blackboard: Blackboard) -> int:
	var see_player = blackboard.get_value("see_player")
	if see_player:
		var player_pos = blackboard.get_value("last_seen_player_pos")
		nav_agent.set_target_position(player_pos)
		blackboard.set_value("is_navigation_finished", false)
	else:
		# Do task maybe, or maybe just do nothing
		pass
		
	return SUCCESS
