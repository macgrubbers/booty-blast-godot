@tool
class_name HasStatusEffect extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("is_dancing"):
		return SUCCESS
	else:
		return FAILURE
