@tool
class_name IsAliveCondition extends BlackboardHasCondition

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var alive = blackboard.get_value("is_alive")
	if alive:
		return SUCCESS
	else:
		return FAILURE
