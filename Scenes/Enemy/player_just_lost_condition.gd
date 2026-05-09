@tool
class_name PlayerJustLostCondition extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player_just_lost = blackboard.get_value("player_just_lost")
	if player_just_lost:
		blackboard.set_value("player_just_lost", false)
		return SUCCESS
	return FAILURE
