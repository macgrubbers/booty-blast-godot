@tool 
class_name StatusEffectAction extends ActionLeaf

@onready var visual_root = $"../../../../../../VisualRoot/LilGooberVisuals"

func before_run(actor: Node, blackboard: Blackboard) -> void:
	visual_root.toggle_boogie(true)

func tick(actor: Node, blackboard: Blackboard) -> int:
	print("DANCING!")
	return RUNNING

func after_run(actor: Node, blackboard: Blackboard) -> void:
	visual_root.toggle_dance(false)
	blackboard.set_value("is_dancing", false)
