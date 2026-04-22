@tool
class_name SeePlayerCondition extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var see_player = blackboard.get_value("see_player")
	if see_player:
		return SUCCESS
	else:
		return FAILURE
