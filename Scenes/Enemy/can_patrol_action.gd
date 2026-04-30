@tool
class_name CanPatrolCondition extends BlackboardHasCondition

func tick(actor: Node, blackboard: Blackboard) -> int:
	var can_patrol = blackboard.get_value("can_patrol")
	if can_patrol:
		return SUCCESS
	else:
		return FAILURE
