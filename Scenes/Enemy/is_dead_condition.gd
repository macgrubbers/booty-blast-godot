@tool
class_name IsAliveCondition extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("is_alive"):
		return SUCCESS
	else:
		return FAILURE
