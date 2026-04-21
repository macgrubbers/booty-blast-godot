@tool
class_name JustAttackedCondition extends BlackboardHasCondition

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var just_attacked = blackboard.get_value("just_attacked")
	if just_attacked:
		return SUCCESS
	else:
		return FAILURE
