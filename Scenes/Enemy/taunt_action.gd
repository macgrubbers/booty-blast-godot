@tool 
class_name TauntAction extends ActionLeaf

@export var duration:float = 3
@onready var duration_timer:Timer = $Timer
@onready var visual_root = $"../../../../../../VisualRoot/LilGooberVisuals"

func before_run(actor: Node, blackboard: Blackboard) -> void:
	duration_timer.one_shot = true
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	visual_root.toggle_dance(true)

func tick(actor: Node, blackboard: Blackboard) -> int:
	print(duration_timer.is_stopped())
	actor.gravity_apply()
	if duration_timer.is_stopped():
		return SUCCESS
	else:
		return RUNNING

func after_run(actor: Node, blackboard: Blackboard) -> void:
	visual_root.toggle_dance(false)
	blackboard.set_value("attack_successful", false)
