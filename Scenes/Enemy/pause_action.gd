@tool
class_name PauseAction extends ActionLeaf

var wait_amount : float = 1
var wait_timer:float = 0
var delta:float

func before_run(actor: Node, blackboard: Blackboard) -> void:
	delta = get_physics_process_delta_time()

func tick(actor: Node, blackboard: Blackboard) -> int:
	var lerp_amount:Vector3 = actor.velocity.lerp(Vector3.ZERO,delta*5)
	actor.velocity.x = lerp_amount.x
	actor.velocity.z = lerp_amount.z
	
	wait_timer += delta
	if wait_timer <= wait_amount:
		return RUNNING
	else:
		return SUCCESS
