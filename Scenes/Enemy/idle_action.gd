@tool
class_name IdleAction extends ActionLeaf

var delta:float

func before_run(actor: Node, blackboard: Blackboard) -> void:
	delta = get_physics_process_delta_time()

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply()
	if !actor.velocity.is_zero_approx():
		actor.velocity.x = move_toward(actor.velocity.x,0, delta*20)
		actor.velocity.z = move_toward(actor.velocity.z,0, delta*20)
	return SUCCESS
