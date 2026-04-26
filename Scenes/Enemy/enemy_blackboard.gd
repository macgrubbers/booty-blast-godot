class_name EnemyBlackboard extends Blackboard



func _ready():
	set_value("is_alive", true)
	set_value("attack_successful", false)
	set_value("see_player", false)
	set_value("in_attack_range",false)
	set_value("can_attack", false)
	set_value("has_task", false)
	set_value("is_navigation_finished",true)

	
	
	for node in get_tree().current_scene.get_children():
		if node.is_in_group("Player"):
			set_value("player_ref", node)
