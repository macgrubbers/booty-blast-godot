@tool
class_name InAttackRangeCondition extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var in_attack_range = blackboard.get_value("in_attack_range")
	if in_attack_range:
		return SUCCESS
	else:
		return FAILURE
