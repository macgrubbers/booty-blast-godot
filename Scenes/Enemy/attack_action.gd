@tool
class_name AttackAction extends ActionLeaf

var delta:float
@onready var charge_time:float = 1
var current_time:float

func before_run(actor: Node, blackboard: Blackboard) -> void:
	var CHARGE_SPEED:float = 20
	var player_pos = blackboard.get_value("player_ref").get_global_position()
	var attack_dir = actor.get_global_position().direction_to(player_pos)
	actor.velocity.x = attack_dir.x * CHARGE_SPEED
	actor.velocity.z = attack_dir.z * CHARGE_SPEED


func tick(actor: Node, blackboard: Blackboard) -> int:
	current_time += delta
	
	if current_time <= charge_time:
		return RUNNING
	else:
		return SUCCESS
