@tool
class_name IsDeadCondition extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("is_dead"):
		return SUCCESS
	else:
		return FAILURE
