@tool
class_name PauseAction extends ActionLeaf

@export var wait_amount : float
var wait_timer:float
var delta:float

func before_run(actor: Node, blackboard: Blackboard) -> void:
	wait_timer = 0
	delta = get_physics_process_delta_time()

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply()
	var lerp_amount:Vector3 = actor.velocity.lerp(Vector3.ZERO,delta*5)
	actor.velocity.x = lerp_amount.x
	actor.velocity.z = lerp_amount.z
	
	wait_timer += delta
	if wait_timer <= wait_amount:
		return RUNNING
	else:
		return SUCCESS
