@tool
class_name SeePlayerOrNavFinishedCondition extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var can_see_player = blackboard.get_value("see_player")
	var nav_finished = blackboard.get_value("is_navigation_finished")
	if can_see_player or !nav_finished:
		return SUCCESS
	else:
		return FAILURE
