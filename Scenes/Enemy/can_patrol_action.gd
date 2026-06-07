@tool
class_name CanPatrolCondition extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value("can_patrol"):
		return SUCCESS
	else:
		return FAILURE
