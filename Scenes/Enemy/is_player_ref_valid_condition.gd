@tool
class_name IsPlayerRefValid extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player_ref = blackboard.get_value("player_ref")
	if player_ref:
		return SUCCESS
	else:
		return FAILURE
