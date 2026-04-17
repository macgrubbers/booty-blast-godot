extends BlackboardHasCondition

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var alive = blackboard.has_value("is_alive")
	
	if alive:
		print(blackboard.get_value("node#"))
		return SUCCESS
	return FAILURE
