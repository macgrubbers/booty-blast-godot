@tool
class_name see_player extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var can_see_player = blackboard.get_value("see_player")
	if can_see_player:
		return SUCCESS
	else:
		return FAILURE
