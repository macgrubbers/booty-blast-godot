@tool
class_name AttackSuccessfulCondition extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var attack_successful = blackboard.get_value("attack_successful")
	if attack_successful:
		return SUCCESS
	else:
		return FAILURE
