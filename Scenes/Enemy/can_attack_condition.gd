@tool
class_name CanAttackCondition extends BlackboardHasCondition

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var can_attack = blackboard.get_value("can_attack")
	if can_attack:
		return SUCCESS
	else:
		return FAILURE
