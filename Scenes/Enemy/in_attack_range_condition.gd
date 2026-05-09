@tool
class_name InAttackRangeCondition extends ConditionLeaf

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var in_attack_range = blackboard.get_value("in_attack_range")
	var see_player = blackboard.get_value("see_player")
	if in_attack_range and see_player:
		return SUCCESS
	else:
		return FAILURE
