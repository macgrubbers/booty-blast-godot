@tool 
class_name TauntAction extends ActionLeaf

@onready var num_of_lands = 3
@onready var lands

func before_run(actor: Node, blackboard: Blackboard) -> void:
	lands = 0

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply()
	
	if actor.is_on_floor():
		if lands < num_of_lands:
			actor.velocity.y = 5
			lands += 1
			return RUNNING
		else:
			return SUCCESS
	return RUNNING

func after_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value("attack_successful", false)
