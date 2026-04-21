@tool
class_name AttackSuccessful extends BlackboardHasCondition

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var just_attacked = blackboard.get_value("attack_successful")
	if just_attacked:
		return SUCCESS
	else:
		return FAILURE
