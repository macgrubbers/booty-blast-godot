@tool
class_name IdleAction extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = blackboard.get_value("delta")
	#actor.check_if_floor()
	
	actor.gravity_apply(delta)
	
	actor.velocity.x = move_toward(actor.velocity.x,0, delta*20)
	actor.velocity.z = move_toward(actor.velocity.z,0, delta*20)
	return SUCCESS
