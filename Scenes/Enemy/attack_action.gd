@tool
class_name AttackAction extends ActionLeaf

var wait_timer : Timer
var attack_timer : float
var attack_dir: Vector3

func before_run(actor: Node, blackboard: Blackboard) -> void:
	print("pre attack prep")
	actor.velocity.x = 0
	actor.velocity.z = 0
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	wait_timer.set_wait_time(1.0)
	wait_timer.start()
	
	attack_timer = 0
	

func tick(actor: Node, blackboard: Blackboard) -> int:
	print(wait_timer.time_left)
	if !wait_timer.is_stopped():
		attack_dir = blackboard.get_value("player_ref").get_global_position().normalized()
		print("waiting to attack")
		return RUNNING
	else:
		wait_timer.stop()
		
		var delta = blackboard.get_value("delta")
		attack_timer += delta
		
		if attack_timer < 0.3:
			actor.velocity.x += attack_dir.x * 5 * delta
			actor.velocity.z += attack_dir.z * 5 * delta
			return RUNNING
		else:
			return SUCCESS
